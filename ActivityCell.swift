//
//  ActivityCell.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 7/3/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import UIKit

class ActivityCell: UITableViewCell {

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var activityTitleLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var activityDescriptionLabel: UILabel!
    
    // configures the cell to the data
    func setActivity(activity: Activity) {
        activityImageView.image = activity.image
        activityTitleLabel.text = activity.title
        activityDateLabel.text = DateFormatter.localizedString(from: activity.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
        activityDescriptionLabel.text = activity.description
        activityDescriptionLabel.lineBreakMode = .byWordWrapping
        activityDescriptionLabel.numberOfLines = 4
    }

}
