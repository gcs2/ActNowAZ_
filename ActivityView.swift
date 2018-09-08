//
//  ActivityView.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 7/2/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import UIKit
import UserNotifications

struct RawActivity: Decodable {
    let title: String
    let description: String
    let date: String
    let imageURL: String
    let report: String
    let link: String
    let phone: String
}

/*
 The opening screen of the app, containing a TableView of the activities
 */
class ActivityView: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var facebookButton: UIButton!
    var theTitle: String = ""
    var theDescription: String = ""
    var theDateString: String = ""
    var theImgURL: URL? = nil
    var activities: [Activity] = []
    var rawActivities: [RawActivity] = []
    
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(parseJSON), for: .valueChanged)
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        facebookButton.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        facebookButton.imageEdgeInsets = UIEdgeInsetsMake(12, 12, 12, 12)
        parseJSON()
        print("Count: " + String(activities.count))
        
        // Configure User Notification Center
        UNUserNotificationCenter.current().delegate = self
        
        UNUserNotificationCenter.current().getNotificationSettings { (notificationSettings) in
            switch notificationSettings.authorizationStatus {
            case .notDetermined:
                self.requestAuthorization(completionHandler: { (success) in
                    guard success else { return }
                    
                    self.scheduleLocalNotification()
                })
            case .authorized:
                self.scheduleLocalNotification()
            case .denied:
                print("Application Not Allowed to Display Notifications")
            }
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        tableView.refreshControl = refresher
        
        navItem.title = "ActNowAZ"
    }
    
    private func requestAuthorization(completionHandler: @escaping (_ success: Bool) -> ()) {
        // Request Authorization
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (success, error) in
            if let error = error {
                print("Request Authorization Failed (\(error), \(error.localizedDescription))")
            }
            
            completionHandler(success)
        }
    }
    
    private func scheduleLocalNotification() {
        
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        // Configure Notification Content
        notificationContent.title = "Get involved!"
        notificationContent.subtitle = "Weekly activism:"
        notificationContent.body = "Check out this week's activity!"
        
        // Add Trigger
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: DateComponents(hour: 9, minute: 0, weekday: 3), repeats: true)
        print(notificationTrigger.nextTriggerDate() ?? "nil")
        
        // Create Notification Request
        let notificationRequest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTrigger)
        
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    @IBAction func didTapFacebook(sender: AnyObject) {
        
    }
    
    func openUrl(_ urlStr:String!) {
        if let url = NSURL(string:urlStr) {
            if(UIApplication.shared.canOpenURL(url as URL)) {
                print("facebook is installed")
                UIApplication.shared.open(url as URL, options: [:], completionHandler: nil)
            }
            
        }
    }
    
    // helper method to add activities
    func createArray(_ oldSize: Int) {
        print("in createArray")
        var i = oldSize
        self.activities = self.activities.reversed()
        while i > 0 {
            self.activities.removeLast()
            i = i-1
        }
        print(self.activities.count)
    }
    
    @objc func parseJSON() {
        let oldSize = self.activities.count
        print("parsing")
        let url = URL(string: "https://raw.githubusercontent.com/carensiehl/ActNowAZ_JSON/master/actnowaz.json")
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            do {
                //Create an array of possible countries
                self.rawActivities = try JSONDecoder().decode([RawActivity].self, from: data!)
                for rawActivity in self.rawActivities {
                    print(rawActivity.title + ": " + rawActivity.description + " at " + rawActivity.date + " displaying " + rawActivity.imageURL)
                    let imgURL = URL(string: rawActivity.imageURL)
                    let img = self.getImage(imageLoc: imgURL!)
                    let newActivity = Activity(image: img, title: rawActivity.title, dateString: rawActivity.date, description: rawActivity.description, report: rawActivity.report, link: rawActivity.link, phone: rawActivity.phone)
                    self.activities.append(newActivity)
                    print(self.activities.count)
                }
                self.createArray(oldSize)
                
                let deadline = DispatchTime.now() + .milliseconds(0)
                DispatchQueue.main.asyncAfter(deadline: deadline) {
                    
                    self.tableView.reloadData()
                    self.refresher.endRefreshing()
                }
            } catch {
                print("We got an error")
            }
            
            }.resume()
    }
    
    func getImage(imageLoc: URL) -> UIImage {
        var theImage: UIImage? = nil
        let data = try? Data(contentsOf: imageLoc)
        
        if let imageData = data {
            theImage = UIImage(data: imageData)
        }
        return theImage!
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cellsegue" {
            let destination = segue.destination as? ActivityInDepthView
            let activityIndex = tableView.indexPathForSelectedRow?.row
            destination?.activityReport = activities[activityIndex!].report
            destination?.activityImage = activities[activityIndex!].image
            destination?.activityDate = DateFormatter.localizedString(from: activities[activityIndex!].date, dateStyle: DateFormatter.Style.long, timeStyle: DateFormatter.Style.none)
            destination?.activityTitle = activities[activityIndex!].title
            destination?.activityLink = activities[activityIndex!].link
            destination?.activityPhone = activities[activityIndex!].phone
        }
    }
    
}

// conform ActivityView to required delegate methods; connects the tableView to the View
extension ActivityView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        
        cell.setActivity(activity: activity)
        return cell
    }
}

extension ActivityView: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}
