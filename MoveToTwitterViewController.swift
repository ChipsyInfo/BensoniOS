//
//  MoveToTwitterViewController.swift
//  WESchool
//
//  Created by chipsy services on 12/12/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class MoveToTwitterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let twitterlink = appDelegate.twitterlink!
        
        let twittertimeline = self.storyboard?.instantiateViewController(withIdentifier: "TwitterTimelineTableViewController") as! TwitterTimelineTableViewController
        //facebkweb.request = request
        twittertimeline.screenName = twitterlink
        twittertimeline.isFromHome = true
        self.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(twittertimeline, animated: false)
        // Do any additional setup after loading the view.
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
