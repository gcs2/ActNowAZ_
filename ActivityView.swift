//
//  ActivityView.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 7/2/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import UIKit

/*
 The opening screen of the app, containing a TableView of the activities
 */
class ActivityView: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    var activities: [Activity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activities = createArray()
    }
    
    // helper method to add activities
    func createArray() -> [Activity] {
        var tempArray: [Activity] = []
        
        // Five default activities
        let activity1 = Activity(image: #imageLiteral(resourceName: "az_flag"), title: "First Activity", dateString: "2018-07-07", description: "The first activity")
        let activity2 = Activity(image: #imageLiteral(resourceName: "saguaro"), title: "Second Activity", dateString: "2018-07-14", description: "The second activity")
        let activity3 = Activity(image: #imageLiteral(resourceName: "barringer_crater"), title: "Third Activity", dateString: "2018-07-21", description: "The third activity")
        let activity4 = Activity(image: #imageLiteral(resourceName: "navajo_flag"), title: "Fourth Activity", dateString: "2018-07-28", description: "The fourth activity")
        let activity5 = Activity(image: #imageLiteral(resourceName: "saguaro_gatherers"), title: "Fifth Activity", dateString: "2018-08-04", description: "The fifth activity")
        
        tempArray.append(activity1)
        tempArray.append(activity2)
        tempArray.append(activity3)
        tempArray.append(activity4)
        tempArray.append(activity5)
        
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
