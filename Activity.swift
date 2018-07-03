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
    
    // to handle Date conversion from Strings
    let dateFormat = "yyyy-MM-dd"
    let dateFormatter = DateFormatter()
    
    init(image: UIImage, title: String, dateString: String, description: String) {
        self.image = image
        self.title = title
        dateFormatter.dateFormat = dateFormat
        date = dateFormatter.date(from: dateString)!
        self.description = description
    }
    
}
