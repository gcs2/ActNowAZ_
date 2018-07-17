//
//  ActivityView.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 7/2/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import UIKit
import UserNotifications

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
    //var activityDataArray: [[String: String]] = [[:]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseJSON()
        
        let center = UNUserNotificationCenter.current()
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: notificationOptions) { (granted, error) in
            if !granted {
                print("something went wrong")
            }
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        //activities = createArray()
        navItem.title = "ActNowAZ"
    }
    
    // helper method to add activities
    func createArray() -> [Activity] {
        print("in createArray")
        var tempArray: [Activity] = []
        
        
        tempArray = tempArray.reversed()
        
        
        for activity in tempArray {
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
            triggerDateComponents.hour = 15
            triggerDateComponents.minute = 46
            triggerDateComponents.second = 25
            print(activity.title)
            print("Notification date: \(triggerDateComponents.year!)-\(triggerDateComponents.month!)-\(triggerDateComponents.day!) at \(triggerDateComponents.hour!):\(triggerDateComponents.minute!):\(triggerDateComponents.second!)")
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: activity.title, content: someContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        return tempArray
    }
    
    func parseJSON() {
        print("parsing")
        let url = URL(string: "https://api.myjson.com/bins/10489u")
        let task = URLSession.shared.dataTask(with: url!) {(data, response, error ) in
            guard error == nil else {
                print("returned error")
                return
            }
            print("no error")
            
            guard let content = data else {
                print("No data")
                return
            }
            print("data exists")
            
            
            guard let json = (try? JSONSerialization.jsonObject(with: content, options: JSONSerialization.ReadingOptions.mutableContainers)) as? [String: Any] else {
                print("Not containing JSON")
                return
            }
            print("contains JSON")
            
            if let titleBoi = json["title"] as? String {
                self.theTitle = titleBoi
            }
            
            if let descBoi = json["description"] as? String {
                self.theDescription = descBoi
            }
            
            if let dateStringBoi = json["date"] as? String {
                self.theDateString = dateStringBoi
            }
            
            if let imageURLStringBoi = json["imageURL"] as? String {
                self.theImgURL = URL(string: imageURLStringBoi)
            }
            
            let theImg = self.getImage(imageLoc: self.theImgURL!)
            
            print("about to print the data array")
            
            
            
            let newActivity = Activity(image: theImg, title: self.theTitle, dateString: self.theDateString, description: self.theDescription)
            self.activities.append(newActivity)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        task.resume()
        
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
