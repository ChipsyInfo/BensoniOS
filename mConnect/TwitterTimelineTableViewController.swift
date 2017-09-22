//
//  TwitterTimelineTableViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 02/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import TwitterKit
class TwitterTimelineTableViewController: TWTRTimelineViewController,ENSideMenuDelegate,TWTRTweetViewDelegate {
    var screenName:String!
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var backimg:UIImage!

    var isFromHome:Bool! = false
    var appDelegate:AppDelegate!
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SelectedOption = "TwitterViewDetailController"
        // Add a button to the center of the view to show the timeline
        self.navigationItem.title = "Twitter Feeds"
        if self.isFromHome == false
        {
            let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            button.setTitle("Back", for: UIControlState())
            backimg = self.setcolorImage(UIImage(named: "bksml")!)
            button.setImage(backimg, for: UIControlState())
            button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
            //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
            let leftButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
            let negativeSpacerright:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.fixedSpace, target: nil, action: nil)
            negativeSpacerright.width = -10
            self.navigationItem.leftBarButtonItems = [leftButton]
        }
        else
        {
            let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            button.setImage(UIImage(named: "home_g"), for: UIControlState())
            button.addTarget(self, action: #selector(self.gotoHome), for: .touchUpInside)
            //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
            let leftButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
            self.navigationItem.leftBarButtonItem = leftButton
        }
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
        let client = TWTRAPIClient()
        self.dataSource = TWTRUserTimelineDataSource(screenName: screenName, apiClient: client)
        self.showTweetActions = false
        self.tweetViewDelegate = self
        
        //self.showTimeline()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        appDelegate.SelectedOption = "TwitterViewDetailController"

    }
    func showTimeline() {
        // Create an API client and data source to fetch Tweets for the timeline
        let client = TWTRAPIClient()
        //TODO: Replace with your collection id or a different data source
        let dataSource = TWTRUserTimelineDataSource(screenName: screenName, apiClient: client)
        
        // Create the timeline view controller
        let timelineViewControlller = TWTRTimelineViewController(dataSource: dataSource)
        // Create done button to dismiss the view controller
        let button = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissTimeline))
        timelineViewControlller.navigationItem.leftBarButtonItem = button
        // Create a navigation controller to hold the
        let navigationController = UINavigationController(rootViewController: timelineViewControlller)
        showDetailViewController(navigationController, sender: self)
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func setcolorImage(_ img:UIImage)-> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
        img.draw(in: rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        
        context.setFillColor(UIColor(hex:0x007AFF)!.cgColor);
        context.fill(rect);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage
    }
    func tweetView(_ tweetView: TWTRTweetView, shouldDisplay controller: TWTRTweetDetailViewController) -> Bool {
        // customize the controller to fit your needs.
        
        // show the view controller in a way that is appropriate for you current setup which may include pushing on a
        // navigation stack or presenting in a pop over controller.
        controller.actionBarInset = -50
        //self.showViewController(controller, sender:self)
        
        // return false to tell Twitter Kit that you will present the controller on your own.
        // return true if you want Twitter Kit to present it for you, this is the default if you don't implement this method.
        return false;
    }
    
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    func gotoHome()
    {
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        if self.isFromHome == true
        {
            hideSideMenuView()
            delay(0.6)
            {
                self.appDelegate.SelectedOption = ""
                NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
                let _ = self.navigationController?.popToRootViewController(animated: true)
            }
        }
        else
        {
            self.appDelegate.SelectedOption = "backToTwitterList"
            hideSideMenuView()
            let _ = self.navigationController?.popViewController(animated: false)
        }
        
        //self.navigationController?.presentViewController(home, animated: true, completion: nil)
    }
    func dismissTimeline() {
        dismiss(animated: true, completion: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
}
