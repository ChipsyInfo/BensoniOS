//
//  PrivacyPolicyViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 05/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class PrivacyPolicyViewController: UIViewController,ENSideMenuDelegate {
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var reachable:Reachability!
    var appDelegate:AppDelegate!
    @IBOutlet weak var privacyWebView: UIWebView!
    
    override func viewDidLoad() {
        reachable = Reachability()
        super.viewDidLoad()
         appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SelectedOption = "PrivacyPolicyViewController"
        privacyWebView.scrollView.bounces = false
        privacyWebView.scrollView.showsHorizontalScrollIndicator = false
        privacyWebView.scrollView.showsVerticalScrollIndicator = false
        self.navigationItem.title = "Privacy Policy"
        let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.setImage(UIImage(named: "home_g"), for: UIControlState())
        button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
        //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
        let rightButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.leftBarButtonItem = rightButton
        self.sideMenuController()?.sideMenu?.delegate = self
        self.sideMenuController()?.sideMenu?.allowRightSwipe = true
        self.sideMenuController()?.sideMenu?.allowPanGesture = true
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = true
        let origImage = UIImage(named: "menu")
        menuButton = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))
        menuButton.setImage(origImage, for: UIControlState())
        menuButton.contentMode = UIViewContentMode.center
        //menuButton.tintColor = UIColor(netHex: 0xFFFFFF)
        // add button images, etc.
        menuButton.addTarget(self, action:#selector(self.menuButtonTouched(_:)), for:UIControlEvents.touchUpInside)
        menu = UIBarButtonItem(customView: menuButton)
        self.navigationItem.rightBarButtonItems = [menu]
        let url = URL (string: "http://mconnect.ideationwizard.com/privacy")
        let requestObj = NSMutableURLRequest(url: url!)
        if reachable.isReachable == true {
            //print("Internet connection OK")
            
            
            privacyWebView.loadRequest(requestObj as URLRequest)
        }
        else
        {
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        appDelegate.SelectedOption = "PrivacyPolicyViewController"

    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func loadAlert()
    {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController (title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
            
            let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                let settingsUrl = URL(string: UIApplicationOpenSettingsURLString)
                if let url = settingsUrl {
                    UIApplication.shared.openURL(url)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alertController.addAction(settingsAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    func gotoHome()
    {
        self.appDelegate.SelectedOption = ""
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
        let _ = self.navigationController?.popToRootViewController(animated: true)
        
    }
}
