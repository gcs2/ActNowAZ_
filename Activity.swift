//
//  Activity.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 7/3/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import Foundation
import UIKit


// Handles the activity information
class Activity {
    var image: UIImage
    var title: String
    var description: String
    var date: Date
    var report: String
    var link: String
    var phone: String
    
    // to handle Date conversion from Strings
    let dateFormat = "yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    
    init(image: UIImage, title: String, dateString: String, description: String, report: String, link: String, phone: String) {
        self.title = title
        dateFormatter.dateFormat = dateFormat
        date = dateFormatter.date(from: dateString)!
        self.description = description
        self.image = image
        self.report = report
        self.link = link
        self.phone = phone
    }
    
}
