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
        
        // Five default image URLs
        let AZFlagURL = URL(string: "https://farm2.staticflickr.com/1826/41480642920_a8bfa15aca.jpg")
        let saguaroURL = URL(string: "https://farm2.staticflickr.com/1786/41480645400_121ce20ae1.jpg")
        let navajoFlagURL = URL(string: "https://farm2.staticflickr.com/1826/28421046857_f9e0758ece.jpg")
        let craterURL = URL(string: "https://farm1.staticflickr.com/913/41480644350_1e0bc8f7ae.jpg")
        let saguaroGatherersURL = URL(string: "https://farm2.staticflickr.com/1803/29421292618_49311ed199.jpg")
        
        let AZFlagImage = getImage(imageLoc: AZFlagURL!)
        let saguaroImage = getImage(imageLoc: saguaroURL!)
        let navajoFlagImage = getImage(imageLoc: navajoFlagURL!)
        let craterImage = getImage(imageLoc: craterURL!)
        let saguaroGatherersImage = getImage(imageLoc: saguaroGatherersURL!)
        
        
        // Five default activities
        let activity1 = Activity(image: AZFlagImage, title: "First Activity", dateString: "2018-07-09", description: "The first activity")
        let activity2 = Activity(image: saguaroImage, title: "Second Activity", dateString: "2018-07-14", description: "The second activity")
        let activity3 = Activity(image: craterImage, title: "Third Activity", dateString: "2018-07-21", description: "The third activity")
        let activity4 = Activity(image: navajoFlagImage, title: "Fourth Activity", dateString: "2018-07-28", description: "The fourth activity")
        let activity5 = Activity(image: saguaroGatherersImage, title: "Fifth Activity", dateString: "2018-08-04", description: "The fifth activity")
        
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
        let cell = tabelView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        cell.setActivity(activity: activity)
        return cell
    }
}
