//
//  ActivityInDepthView.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 7/26/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import UIKit

class ActivityInDepthView: UIViewController {
    @IBOutlet var thisView: UIView!
    @IBOutlet weak var specifiedActivityImageView: UIImageView!
    @IBOutlet weak var activityReportLabel: UILabel!
    @IBOutlet weak var activityDateLabel: UILabel!
    @IBOutlet weak var activityTitleLabel: UILabel!
    
    var activityReport = String()
    var activityDate = String()
    var activityImage = UIImage()
    var activityTitle = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityReportLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        activityReportLabel.numberOfLines = 0
        activityReportLabel.text = activityReport
        specifiedActivityImageView.image = activityImage
        activityDateLabel.text = activityDate
        activityTitleLabel.text = activityTitle
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
