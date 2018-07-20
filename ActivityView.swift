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
}

/*
 The opening screen of the app, containing a TableView of the activities
 */
class ActivityView: UIViewController {
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
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
        
        parseJSON()
        print("Count: " + String(activities.count))
        let center = UNUserNotificationCenter.current()
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: notificationOptions) { (granted, error) in
            if !granted {
                print("something went wrong")
            }
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        tableView.refreshControl = refresher
        
        navItem.title = "ActNowAZ"
    }
    
    // helper method to add activities
    func createArray(_ oldSize: Int) {
        print("in createArray")
        var i = oldSize
        self.activities = self.activities.reversed()
        while i > 0 {
            print("popped")
            self.activities.popLast()
            i = i-1
        }
        print(self.activities.count)
        
        for activity in self.activities {
            let someContent = UNMutableNotificationContent()
            someContent.title = activity.title
            someContent.subtitle = activity.description
            someContent.body = "Check it out!"
            someContent.badge = 1
            
            let userCalendar = Calendar.current
            let date = activity.date
            var triggerDateComponents = DateComponents()
            triggerDateComponents.year = userCalendar.component(.year, from: date)
            triggerDateComponents.month = userCalendar.component(.month, from: date)
            triggerDateComponents.day = userCalendar.component(.day, from: date) - 1
            triggerDateComponents.hour = 16
            triggerDateComponents.minute = 20
            triggerDateComponents.second = 26
            print(activity.title)
            print("Notification date: \(triggerDateComponents.year!)-\(triggerDateComponents.month!)-\(triggerDateComponents.day!) at \(triggerDateComponents.hour!):\(triggerDateComponents.minute!):\(triggerDateComponents.second!)")
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: activity.title, content: someContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
    }
    
    @objc func parseJSON() {
        let oldSize = self.activities.count
        print("parsing")
        let url = URL(string: "https://raw.githubusercontent.com/gcs2/ActNowAZJSON/master/actnowaz.json")
        URLSession.shared.dataTask(with: url!) {(data, response, error) in
            do {
                //Create an array of possible countries
                self.rawActivities = try JSONDecoder().decode([RawActivity].self, from: data!)
                for rawActivity in self.rawActivities {
                    print(rawActivity.title + ": " + rawActivity.description + " at " + rawActivity.date + " displaying " + rawActivity.imageURL)
                    let imgURL = URL(string: rawActivity.imageURL)
                    let img = self.getImage(imageLoc: imgURL!)
                    let newActivity = Activity(image: img, title: rawActivity.title, dateString: rawActivity.date, description: rawActivity.description)
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
