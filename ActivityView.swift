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

    @IBAction func būton(_ sender: Any) {
        let content = UNMutableNotificationContent()
        content.title = "The five seconds are up!"
        content.subtitle = "Come on, tap me!"
        content.body = "You know you want to ;)"
        content.badge = 1
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier: "timerDone", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var tabelView: UITableView!
    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let center = UNUserNotificationCenter.current()
        let notificationOptions: UNAuthorizationOptions = [.alert, .sound, .badge]
        center.requestAuthorization(options: notificationOptions) { (granted, error) in
            if !granted {
                print("something went wrong")
            }
        }
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        activities = createArray()
        navItem.title = "ActNowAZ"
    }
    
    // helper method to add activities
    func createArray() -> [Activity] {
        var tempArray: [Activity] = []
        
        // Five default activities
        let activity1 = Activity(image: #imageLiteral(resourceName: "az_flag"), title: "First Activity", dateString: "2018-07-08", description: "The first activity")
        let activity2 = Activity(image: #imageLiteral(resourceName: "saguaro"), title: "Second Activity", dateString: "2018-07-14", description: "The second activity")
        let activity3 = Activity(image: #imageLiteral(resourceName: "barringer_crater"), title: "Third Activity", dateString: "2018-07-21", description: "The third activity")
        let activity4 = Activity(image: #imageLiteral(resourceName: "navajo_flag"), title: "Fourth Activity", dateString: "2018-07-28", description: "The fourth activity")
        let activity5 = Activity(image: #imageLiteral(resourceName: "saguaro_gatherers"), title: "Fifth Activity", dateString: "2018-08-04", description: "The fifth activity")
        
        tempArray.append(activity1)
        tempArray.append(activity2)
        tempArray.append(activity3)
        tempArray.append(activity4)
        tempArray.append(activity5)
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
            triggerDateComponents.minute = 13
            triggerDateComponents.second = 0
            print(activity.title)
            print("Notification date: \(triggerDateComponents.year!)-\(triggerDateComponents.month!)-\(triggerDateComponents.day!) at \(triggerDateComponents.hour!):\(triggerDateComponents.minute!):\(triggerDateComponents.second!)")
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)
            let request = UNNotificationRequest(identifier: activity.title, content: someContent, trigger: trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        }
        
        return tempArray
    }
    
}

// conform ActivityView to required delegate methods; connects the tableView to the View
extension ActivityView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return activities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let activity = activities[indexPath.row]
        let cell = tabelView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        cell.setActivity(activity: activity)
        return cell
    }
}
