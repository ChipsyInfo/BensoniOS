//
//  HomeViewController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 27/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController,ENSideMenuDelegate,UIPopoverPresentationControllerDelegate,PathMenuDelegate,AccordionViewControllerDelegate {
    var  menuButton:UIButton!
    var isValuePresent:Bool! = false
    var accordionVC:AccordionViewController!
    var homeData:HomeInfoDataController!
    var eventsDataArray:NSArray!
    var newsDataArray:NSArray!
    var flowmenu:PathMenu!
    var bannerArray:NSArray!
    var twitterlink:String!
    var imgarray:[UIImage] = [UIImage]()
    var actInd: UIActivityIndicatorView = UIActivityIndicatorView()
    var homeImageView:UIImageView = UIImageView()
    var  menu:UIBarButtonItem!
    var appDelegate:AppDelegate!
    var reachable:Reachability!
    //var spinner:SARMaterialDesignSpinner!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    var screenSize:CGSize!
    @IBOutlet weak var spinner: SARMaterialDesignSpinner!
    @IBOutlet weak var TabBarView: UITabBar!
    
    override func awakeFromNib() {
        reachable = Reachability()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        _ = appDelegate.mainUrlString
        
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.accordionVC = appDelegate.accordionVC
        self.accordionVC.delegate = self
        var fbmenu = UIImage(named: "fab_sml")!
        fbmenu = self.setcolorImage(fbmenu, hexcolr: 0x3b5998)
        let menuItemHighlitedImage = UIImage()
        
        var newsmenu = UIImage(named: "fab_sml")!
        newsmenu = self.setcolorImage(fbmenu, hexcolr: 0xFB852E)
        
        var tweetmenu = UIImage(named: "fab_sml")!
        tweetmenu = self.setcolorImage(fbmenu, hexcolr: 0x55acee)
        
        
        
        let fbimage = UIImage(named: "fab_fb")!
        let newsimage = UIImage(named: "fab_news")!
        let twitterimage = UIImage(named: "fab_tweet")!
        let starMenuItem1 = PathMenuItem(image: fbmenu, highlightedImage: menuItemHighlitedImage, contentImage: fbimage)
        
        let starMenuItem2 = PathMenuItem(image: newsmenu, highlightedImage: menuItemHighlitedImage, contentImage: newsimage)
        
        let starMenuItem3 = PathMenuItem(image: tweetmenu, highlightedImage: menuItemHighlitedImage, contentImage: twitterimage)
        
        let starMenuItem4 = PathMenuItem(image: UIImage(), highlightedImage: UIImage(), contentImage: UIImage())
        
        let starMenuItem5 = PathMenuItem(image: UIImage(), highlightedImage: UIImage(), contentImage: UIImage())
        
        let items = [starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5]
        var menuimg = UIImage(named: "fab_nor")!
        menuimg = self.setcolorImage(menuimg, hexcolr: 0x009688)
        let startItem = PathMenuItem(image: menuimg,
                                     highlightedImage: UIImage(),
                                     contentImage: UIImage(named: "fab_more"),
                                     highlightedContentImage: UIImage())
        
        flowmenu = PathMenu(frame: view.bounds, startItem: startItem, items: items)
        
        flowmenu.delegate = self
        flowmenu.startPoint     = CGPoint(x: UIScreen.main.bounds.width - 40.0, y: view.frame.size.height - 40.0)
        /*flowmenu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
         flowmenu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/5) * 1/2
         flowmenu.timeOffset     = 0.0
         flowmenu.farRadius      = 70
         flowmenu.nearRadius     = 40
         flowmenu.endRadius      = 70
         flowmenu.animationDuration = 0.5
         */
        flowmenu.menuWholeAngle = CGFloat(M_PI) - CGFloat(M_PI/5)
        flowmenu.rotateAngle    = -CGFloat(M_PI_2) + CGFloat(M_PI/8) * 1/2
        flowmenu.timeOffset     = 0.0
        flowmenu.farRadius      = 90.0
        flowmenu.nearRadius     = 80.0
        flowmenu.endRadius      = 80.0
        flowmenu.animationDuration = 0.5
        
        /*if self.iPad == true
        {
            self.screenSize = UIScreen.main.bounds.size
            /* do something specifically for iPad. */
            self.accordionVC.view.frame  = CGRect(x: 0.0, y: 824, width: self.view.frame.size.width, height: self.view.frame.size.height)
            if (self.screenSize.height > 1300) {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: self.screenSize.width, height: 1110))
            }
            else
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: self.screenSize.width, height: 775))
            }
            
        }
        if self.iPhone == true
        {
            /* do something specifically for iPhone or iPod touch. */
            self.accordionVC.view.frame  = CGRect(x: 0.0, y: 300.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.screenSize = UIScreen.main.bounds.size
            
            if(self.screenSize.height == 480)
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 320, height: 171))
            }
            else if(self.screenSize.height == 568)
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 320, height: 270))
                
                
            }
            else if(self.screenSize.height == 667)
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 375, height: 400))
                
                
            }
            else
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 414, height: 510))
                
                
            }
        }*/
        if self.iPad == true
        {
            self.screenSize = UIScreen.main.bounds.size
            /* do something specifically for iPad. */
            self.accordionVC.view.frame  = CGRect(x: 0.0, y: 824, width: self.view.frame.size.width, height: self.view.frame.size.height)
            if (self.screenSize.height > 1300) {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: self.screenSize.width, height: 1110))
            }
            else
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: self.screenSize.width, height: 775))
            }
            
        }
        if self.iPhone == true
        {
            /* do something specifically for iPhone or iPod touch. */
            self.accordionVC.view.frame  = CGRect(x: 0.0, y: 300.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.screenSize = UIScreen.main.bounds.size
            
            if(self.screenSize.height == 480)
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 320, height: 220))
                
            }
            else if(self.screenSize.height == 568)
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 320, height: 310))
                
                
            }
            else if(self.screenSize.height == 667)
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 375, height: 410))
                
                
            }
            else
            {
                self.homeImageView = self.loadImageViewFrame(self.homeImageView, rect: CGRect(x: 0, y: 64, width: 414, height: 510))
                
                
            }
        }
        
        self.view.addSubview(self.homeImageView)
         if reachable.isReachable == true {
            //print("Internet connection OK")
            
            if appDelegate.openNews == true
            {
                DispatchQueue.main.async
                {
                    self.homeData = HomeInfoDataController()
                    let newsview = self.storyboard?.instantiateViewController(withIdentifier: "NewsAllViewController")
                    self.navigationController?.pushViewController(newsview!, animated: true)
                }
            }
            else
            {
                homeData = HomeInfoDataController()
                spinner.strokeColor =  UIColor.blue
                spinner.startAnimating()
            }
            
        }
        else
        {
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
        // Do any additional setup after loading the view, typically from a nib.
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
        //self.navigationItem.rightBarButtonItems = [menu]
        let button:UIButton   = UIButton(frame: CGRect(x: 0, y: 0, width: 24, height: 24))//[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        button.setImage(UIImage(named: "home_b"), for: UIControlState())
        //[button setImage:[UIImage imageNamed:@"home_b"] forState:UIControlStateNormal];
        //let rightButton:UIBarButtonItem  = UIBarButtonItem(customView: button)//[[UIBarButtonItem alloc] initWithCustomView:button];
        //self.navigationItem.leftBarButtonItem = rightButton
        let imagetap = UITapGestureRecognizer(target: self, action: #selector(self.imageTouched))
        
        self.homeImageView.addGestureRecognizer(imagetap)
        self.view.autoresizingMask = [.flexibleWidth,.flexibleRightMargin,.flexibleLeftMargin]//UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin;
        //self.homeImageView.contentMode = .ScaleToFill
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadHomeScreenInfo), name: NSNotification.Name(rawValue: "dataIsReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateImages), name: NSNotification.Name(rawValue: "updateImages"), object: nil)
        self.view.clipsToBounds = true
        NotificationCenter.default.addObserver(self, selector: #selector(self.displayFlowingActionMenu), name: NSNotification.Name(rawValue: "displayflowingbuttonmenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.hideFlowingActionMenu), name: NSNotification.Name(rawValue: "hideflowingbuttonmenu"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableTwitterCount(_:)), name: NSNotification.Name(rawValue: "reloadTwitterCount"), object: nil)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func updateImages()
    {
        self.homeImageView.animationImages = self.imgarray
        UIView.animate(withDuration: 5.0, delay: 0.0, options: [.repeat, .autoreverse], animations: {
            self.homeImageView.transform = CGAffineTransform(scaleX: 1.2,y: 1.2)
            }, completion: {(value: Bool) in})
        /*[UIView animateWithDuration:5.0f delay:0.0 options: UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionRepeat | UIViewAnimationOptionAutoreverse
         animations:^{
         self.homeImageView.transform = CGAffineTransformMakeScale(1.2,1.2);
         }
         completion:^(BOOL finished){
         }];*/
        self.homeImageView.startAnimating()
    }
    func displayFlowingActionMenu()
    {
        self.flowmenu.isHidden = false
    }
    func hideFlowingActionMenu()
    {
        self.flowmenu.isHidden = true
    }
    func reloadTableTwitterCount(_ notification:Notification){
        DispatchQueue.main.async {
            let userInfo = notification.userInfo! as [AnyHashable : Any]
            //self.twitterCount = userInfo["number"] as! Int
            self.twitterlink = userInfo["link"] as! String
            //self.tableView.reloadData()
        }
    }
    func moveToScreen(_ index: Int) {
        if index == 1
        {
            let twitterlink = self.twitterlink!
            
            let twittertimeline = self.storyboard?.instantiateViewController(withIdentifier: "TwitterTimelineTableViewController") as! TwitterTimelineTableViewController
            //facebkweb.request = request
            twittertimeline.isFromHome = true
            twittertimeline.screenName = twitterlink
            self.navigationController?.pushViewController(twittertimeline, animated: true)
        }
        if index == 2
        {
            let newsview = self.storyboard?.instantiateViewController(withIdentifier: "NewsAllViewController")
            self.navigationController?.pushViewController(newsview!, animated: true)
        }
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
    func pathMenu(_ menu: PathMenu, didSelectIndex idx: Int) {
        //print("Select the index : \(idx)")
        if idx == 0
        {
            
            //flowmenu.handleTap()
            flowmenu.contentImage = UIImage(named: "fab_more")
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadFbSelected", object: self, userInfo: nil)
            
            DispatchQueue.main.async{
                self.accordionVC.accordionSectionWasSelected(self.accordionVC.newsSection)
                let fbview = self.storyboard?.instantiateViewController(withIdentifier: "FacebookViewController")
                self.navigationController?.pushViewController(fbview!, animated: true)
            }
            
            
            
        }
        else if idx == 1
        {
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadNewsSelected", object: self, userInfo: nil)
            
            //flowmenu.handleTap()
            flowmenu.contentImage = UIImage(named: "fab_more")
            
            DispatchQueue.main.async{
                self.accordionVC.accordionSectionWasSelected(self.accordionVC.newsSection)
                let newsview = self.storyboard?.instantiateViewController(withIdentifier: "NewsAllViewController")
                self.navigationController?.pushViewController(newsview!, animated: true)
            }
        }
        else
        {
            // NSNotificationCenter.defaultCenter().postNotificationName("reloadTwitterSelected", object: self, userInfo: nil)
            
            //flowmenu.handleTap()
            flowmenu.contentImage = UIImage(named: "fab_more")
            
            DispatchQueue.main.async{
                self.accordionVC.accordionSectionWasSelected(self.accordionVC.newsSection)
                let twitterview = self.storyboard?.instantiateViewController(withIdentifier: "TwitterViewController")
                self.navigationController?.pushViewController(twitterview!, animated: true)
            }
            
            
        }
    }
   
    func pathMenuWillAnimateOpen(_ menu: PathMenu) {
        //print("Menu will open!")
    }
    
    func pathMenuWillAnimateClose(_ menu: PathMenu) {
        //print("Menu will close!")
        //flowmenu.contentImage = UIImage(named: "fab_more")
    }
    
    func pathMenuDidFinishAnimationOpen(_ menu: PathMenu) {
        //print("Menu was open!")
    }
    
    func pathMenuDidFinishAnimationClose(_ menu: PathMenu) {
        if menu.ButtonOpen == true
        {
            
        }
        //print("Menu was closed!")
        //flowmenu.contentImage = UIImage(named: "fab_more")
    }
    func imageTouched()
    {
        if sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            hideSideMenuView()
        }
        
    }
    func loadHomeScreenInfo()
    {
        self.isValuePresent = homeData.isValuePresent
        DispatchQueue.main.async{
            self.view.viewWithTag(555)?.removeFromSuperview()
            self.view.viewWithTag(556)?.removeFromSuperview()
            self.view.autoresizingMask = [.flexibleWidth,.flexibleRightMargin,.flexibleLeftMargin]
            
            
            self.view.clipsToBounds = true
            
            self.accordionVC.view.tag = 555
            
            self.homeImageView.animationDuration = 15
            self.loadImages(self.homeImageView)
            self.homeImageView.contentMode = .scaleAspectFill
            //startAnimating];
            self.homeImageView.tag = 556
            
            let storyboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            //UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            let EventTableViewController:EventsHomeTableViewController = storyboard.instantiateViewController(withIdentifier: "EventsHomeTableViewController") as! EventsHomeTableViewController//[storyboard instantiateViewControllerWithIdentifier:@"EventsHomeTableViewController"];
            let NewsTableViewController = self.storyboard?.instantiateViewController(withIdentifier: "NewsHomeTableViewController") as! NewsHomeTableViewController
            
            if self.isValuePresent == true
            {
                EventTableViewController.homeData = self.homeData
                NewsTableViewController.homeData = self.homeData
                self.eventsDataArray = self.homeData.eventsArray
                self.newsDataArray = self.homeData.newsArray
                
                let newstitleArray:NSMutableArray = NSMutableArray()
                let newsdetailArray:NSMutableArray = NSMutableArray()
                for news in self.newsDataArray
                {
                    let newstitle = (news as AnyObject).value(forKey: "title") as! String
                    newstitleArray.add(newstitle)
                    
                    let newsdetail = (news as AnyObject).value(forKey: "descriptn") as! String
                    newsdetailArray.add(newsdetail)
                    
                }
                
                self.accordionVC.newscount = UInt32(self.newsDataArray.count)
                self.accordionVC.eventcount = UInt32(self.eventsDataArray.count)
                let eventtitleArray:NSMutableArray = NSMutableArray()
                let eventdetailArray:NSMutableArray = NSMutableArray()
                let eventdateStringarray:NSMutableArray = NSMutableArray()
                let eventtimearray:NSMutableArray = NSMutableArray()
                for event in self.eventsDataArray
                {
                    let eventtitle = (event as AnyObject).value(forKey: "title") as! String
                    eventtitleArray.add(eventtitle)
                    var eventdetail = "at "
                    eventdetail.append((event as AnyObject).value(forKey: "place") as! String)
                    eventdetailArray.add(eventdetail)
                    
                    let eventdate = (event as AnyObject).value(forKey: "date") as! String
                    let eventtime = (event as AnyObject).value(forKey: "time") as! String
                    eventtimearray.add(eventtime)
                    
                    let date = eventdate
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy"
                    //dateFormatter.locale = NSLocale.currentLocale()
                    // convert string into date
                    //dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
                    let dateValue:Date  =  dateFormatter.date(from: date)!
                    //let greater = dateValue.timeIntervalSince1970 < NSDate().timeIntervalSince1970
                    let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                    let components = (calendar as NSCalendar).components([.month, .day], from: dateValue)
                    let month = components.month
                    let day = components.day
                    let monthstring:String!
                    
                    switch(month)
                    {
                    case 1?:
                        monthstring = "January"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        break
                    case 2?:
                        monthstring = "February"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 3?:
                        monthstring = "March"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 4?:
                        monthstring = "April"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 5?:
                        monthstring = "May"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 6?:
                        monthstring = "June"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 7?:
                        monthstring = "July"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 8?:
                        monthstring = "August"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 9?:
                        monthstring = "September"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        break
                    case 10?:
                        monthstring = "October"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        break
                    case 11?:
                        monthstring = "November"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    case 12?:
                        monthstring = "December"
                        let datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                        eventdateStringarray.add(datestring)
                        
                        break
                    default:
                        break
                        
                    }
                    
                }
                EventTableViewController.eventTitleArray = eventtitleArray
                EventTableViewController.eventDetailArray = eventdetailArray
                EventTableViewController.eventTimeArray = eventtimearray
                NewsTableViewController.newsTitleArray = newstitleArray
                NewsTableViewController.newsDetailArray = newsdetailArray
                self.accordionVC.newsTitleArray = newstitleArray
                self.accordionVC.newsDetailArray = newsdetailArray
                self.accordionVC.eventTitleArray = eventtitleArray
                self.accordionVC.eventDetailArray = eventdetailArray
                self.accordionVC.eventDateArray = eventdateStringarray
                
            }
            
            //self.accordionVC.createSectionWithContent(EventTableViewController, title: eventTitleArray as [AnyObject], detail: eventDetailArray as [AnyObject], dateContent: eventDateArray as [AnyObject])
            //self.accordionVC.createSectionWithContent(NewsTableViewController, title: newsTitleArray as [AnyObject], detail: newsDetailArray as [AnyObject], dateContent: [""])
           _ = self.accordionVC.createSectionWithContent(EventTableViewController, sectionTitle: self.accordionVC.eventTitleArray, detailData: self.accordionVC.eventDetailArray, dateInfo: self.accordionVC.eventDateArray)
           _ =  self.accordionVC.createSectionWithContent(NewsTableViewController, sectionTitle: self.accordionVC.newsTitleArray, detailData: self.accordionVC.newsDetailArray, dateInfo: [""])
            //[self.accordionVC createSectionWithContent:EventTableViewController title:eventTitleArray detail:eventDetailArray dateContent:eventDateArray];
            
            //[self.accordionVC createSectionWithContent:NewsTableViewController title:newsTitleArray detail:newsDetailArray dateContent:@[@""]];
            
            self.accordionVC.isFullscreen = true;
            
            
            self.homeImageView.animationDuration = 15 // Animation duration
            
            self.homeImageView.startAnimating()
            self.view.addSubview(self.accordionVC.view)
            self.view.addSubview(self.flowmenu)
            DispatchQueue.main.async {
                self.view.bringSubview(toFront: self.TabBarView)
            }
            self.flowmenu.isHidden = true
            self.view.setNeedsLayout()
        }
        
        //actInd.stopAnimating()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        
        
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationItem.title = "mConnect"
        if self.isValuePresent == true
        {
            self.homeData.updateScreenData()
            self.updateImages()
            //self.homeImageView.animationDuration = 15
            //self.loadImages(self.homeImageView)
            //self.homeImageView.contentMode = .scaleAspectFill
            //startAnimating];
            //self.homeImageView.tag = 556
            self.homeImageView.animationDuration = 15 // Animation duration
            
            self.homeImageView.startAnimating()
            //spinner.strokeColor =  UIColor.blueColor()
            //spinner.startAnimating()
        }
        
        
    }
    
    func newDateString(_ month:String,day:Int,time:String)-> String
    {
        var datestring = NSMutableString()
        datestring = NSMutableString(string: month)
        datestring.append(" ")
        datestring.append(String(day))
        datestring.append(",")
        datestring.append(" ")
        datestring.append(time)
        return datestring as String
    }
    func loadImages(_ imageView:UIImageView)
    {
        
        
        self.bannerArray = self.homeData.bannerArray
        for banners in self.bannerArray
        {
            let banner = (banners as AnyObject).value(forKey: "imagepath") as! String
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let mainUrl:NSMutableString = NSMutableString(string: appDelegate.mainUrlString)
            
            
            mainUrl.append(banner)
            let string = mainUrl
            var modifiedUrlString:NSString!
            // alternative: not case sensitive
            if string.lowercased.range(of: ".jpg") != nil {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpg", with: "_l.jpg") as NSString!
            }
            else if string.lowercased.range(of: ".png") != nil
            {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".png", with: "_l.png") as NSString!
            }
            else
            {
                modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpeg", with: "_l.jpeg") as NSString!
            }
            
            self.imageFromServerURL(modifiedUrlString as String)
            //imageView.animationImages = imgarray as! [UIImage]
            
        }
        
        imageView.animationImages = self.imgarray
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateImages"), object: self, userInfo: nil)
        
        
        
        //imageView.animationImages //= [slide1,slide2,slide3]
    }
    func imageFromServerURL(_ urlString: String) {
        
        URLSession.shared.dataTask(with: URL(string: urlString)!, completionHandler: { (data, response, error) -> Void in
            
            if error != nil {
                //print(error!)
                return
            }
            DispatchQueue.main.async(execute: { () -> Void in
                let image = UIImage(data: data!)
                self.imgarray.append(image!)
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateImages"), object: self, userInfo: nil)
            })
            
        }).resume()
        self.spinner.stopAnimating()
    }
    func setcolorImage(_ img:UIImage,hexcolr:Int)-> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
        img.draw(in: rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        
        context.setFillColor(UIColor(hex:hexcolr)!.cgColor);
        context.fill(rect);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage
    }
    func loadImageViewFrame(_ imageView:UIImageView,rect:CGRect)-> UIImageView
    {
        var imageView = imageView
        imageView = UIImageView(frame: rect)
        return imageView
    }
    
    
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    public convenience init?(hexString: String, alpha: Float) {
        var hex = hexString
        
        // Check for hash and remove the hash
        if hex.hasPrefix("#") {
            hex = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 1))
        }
        
        if (hex.range(of: "(^[0-9A-Fa-f]{6}$)|(^[0-9A-Fa-f]{3}$)", options: .regularExpression) != nil) {
            
            // Deal with 3 character Hex strings
            if hex.characters.count == 3 {
                let redHex   = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 1))
                let greenHex = hex.substring(with: Range<String.Index>(hex.characters.index(hex.startIndex, offsetBy: 1) ..< hex.characters.index(hex.startIndex, offsetBy: 2)))
                let blueHex  = hex.substring(from: hex.characters.index(hex.startIndex, offsetBy: 2))
                
                hex = redHex + redHex + greenHex + greenHex + blueHex + blueHex
            }
            
            let redHex = hex.substring(to: hex.characters.index(hex.startIndex, offsetBy: 2))
            let greenHex = hex.substring(with: Range<String.Index>(hex.characters.index(hex.startIndex, offsetBy: 2) ..< hex.characters.index(hex.startIndex, offsetBy: 4)))
            let blueHex = hex.substring(with: Range<String.Index>(hex.characters.index(hex.startIndex, offsetBy: 4) ..< hex.characters.index(hex.startIndex, offsetBy: 6)))
            
            var redInt:   CUnsignedInt = 0
            var greenInt: CUnsignedInt = 0
            var blueInt:  CUnsignedInt = 0
            
            Scanner(string: redHex).scanHexInt32(&redInt)
            Scanner(string: greenHex).scanHexInt32(&greenInt)
            Scanner(string: blueHex).scanHexInt32(&blueInt)
            
            self.init(red: CGFloat(redInt) / 255.0, green: CGFloat(greenInt) / 255.0, blue: CGFloat(blueInt) / 255.0, alpha: CGFloat(alpha))
        }
        else {
            // Note:
            // The swift 1.1 compiler is currently unable to destroy partially initialized classes in all cases,
            // so it disallows formation of a situation where it would have to.  We consider this a bug to be fixed
            // in future releases, not a feature. -- Apple Forum
            self.init()
            return nil
        }
    }
    
    /**
     Create non-autoreleased color with in the given hex value. Alpha will be set as 1 by default.
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - returns: A color with the given hex value
     */
    public convenience init?(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    /**
     Create non-autoreleased color with in the given hex value and alpha
     - parameter hex: The hex value. For example: 0xff8942 (no quotation).
     - parameter alpha: The alpha value, a floating value between 0 and 1.
     - returns: color with the given hex value and alpha
     */
    public convenience init?(hex: Int, alpha: Float) {
        var hexString = String(format: "%2X", hex)
        let leadingZerosString = String(repeating: "0", count: 6 - hexString.characters.count)
        hexString = leadingZerosString + hexString
        self.init(hexString: hexString as String , alpha: alpha)
    }
}
extension UIImage {
    class func imageWithColor(_ color: UIColor) -> UIImage {
        let rect: CGRect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), false, 0)
        color.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
