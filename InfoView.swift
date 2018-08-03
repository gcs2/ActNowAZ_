//
//  InfoView.swift
//  ActNowAZ
//
//  Created by Geoffrey Salmon on 8/3/18.
//  Copyright © 2018 Geoffrey Salmon. All rights reserved.
//

import UIKit

class InfoView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @IBAction func fbButtonTapped(_ sender: Any) {
        UIApplication.shared.open(URL(string: "https://www.facebook.com/groups/229279484191710/")!, options: [:], completionHandler: nil)
    }
    
    @IBAction func websiteButtonTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "http://geoffreysalmon.com")!, options: [:], completionHandler: nil)
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
