//
//  NewsAllViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 09/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
var CellnewsAllIdentifier = "NewsAllCell"
class NewsAllViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,ENSideMenuDelegate,PathMenuDelegate {
    
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var flowmenu:PathMenu!
    var isValuePresent:Bool! = false
    var newsarray:NSMutableArray! = NSMutableArray()
    var imgarray:[UIImage]! = []
    var newsAllData:NewsAllInfoDataController!
    var newsHomeImage:UIImage!
    var spinner:SARMaterialDesignSpinner!
    var reachable:Reachability!
    var Emptylabel:UILabel!
    var appDelegate:AppDelegate!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    @IBOutlet weak var newsAllTable: UITableView!
    @IBOutlet weak var NewsAllTableViewTopConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        
    }
    override func viewDidLoad() {
        reachable = Reachability()
        super.viewDidLoad()
        appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.SelectedOption = "NewsAllViewController"
        //self.edgesForExtendedLayout = []
        DispatchQueue.main.async {
            self.Emptylabel = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-(50/2), width: UIScreen.main.bounds.width, height: 50))
            self.Emptylabel.textColor = UIColor.black
            self.Emptylabel.numberOfLines = 3
            self.Emptylabel.font = UIFont.systemFont(ofSize: 18)
            self.Emptylabel.textAlignment = .center
            self.Emptylabel.text = "There are no news at this moment. Please check back later…"
            self.view.addSubview(self.Emptylabel)
            self.view.bringSubview(toFront: self.Emptylabel)
            self.Emptylabel.alpha = 0
        }
        if reachable.isReachable == true {
            //print("Internet connection OK")
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openNews = false
            newsAllData = NewsAllInfoDataController()
            self.spinner = SARMaterialDesignSpinner(frame: CGRect(x: self.view.frame.width/2 - 25,y: (self.view.frame.height)/2 - 25,width: 50,height: 50))
            self.view.addSubview(self.spinner)
            spinner.strokeColor =  UIColor.blue
            spinner.startAnimating()
        }
        else
        {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.openNews = false
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
        self.modalPresentationStyle = .currentContext
        newsAllTable.delegate = self
        newsAllTable.dataSource = self
        
        //
        self.navigationItem.title = "News"
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
        flowmenu.menuWholeAngle = CGFloat(Double.pi) - CGFloat(Double.pi/5)
        flowmenu.rotateAngle    = -CGFloat(Double.pi/2) + CGFloat(Double.pi/8) * 1/2
        flowmenu.timeOffset     = 0.0
        flowmenu.farRadius      = 90.0
        flowmenu.nearRadius     = 80.0
        flowmenu.endRadius      = 80.0
        flowmenu.animationDuration = 0.5
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTableData), name: NSNotification.Name(rawValue: "newsAllDataReady"), object: nil)
        //NSNotificationCenter.defaultCenter().addObserver(self,selector:#selector(self.loadTableData),name:"newsAllDataReady", object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        //self.animateTable()
    }
    func pathMenu(_ menu: PathMenu, didSelectIndex idx: Int) {
        //print("Select the index : \(idx)")
        if idx == 0
        {
            flowmenu.handleTap()
            // NSNotificationCenter.defaultCenter().postNotificationName("reloadFbSelected", object: self, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.facebookCount == 1
            {
                let urlString = appDelegate.fblink
                let url:URL = URL(string: urlString!)!
                let request = NSMutableURLRequest(url: url)
                let facebkweb = self.storyboard?.instantiateViewController(withIdentifier: "FacebookWebViewController") as! FacebookWebViewController
                facebkweb.request = request
                facebkweb.isFromHome = true
                self.navigationController?.pushViewController(facebkweb, animated: false)
                
            }
            else
            {
                let fbview = self.storyboard?.instantiateViewController(withIdentifier: "FacebookViewController")
                self.navigationController?.pushViewController(fbview!, animated: true)
            }
            
            
        }
        else if idx == 1
        {
            flowmenu.contentImage = UIImage(named: "fab_more")
        }
        else
        {
            flowmenu.handleTap()
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadTwitterSelected", object: self, userInfo: nil)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            if appDelegate.twitterCount == 1
            {
                let twitterlink = appDelegate.twitterlink
                
                let twittertimeline = self.storyboard?.instantiateViewController(withIdentifier: "TwitterTimelineTableViewController") as! TwitterTimelineTableViewController
                //facebkweb.request = request
                twittertimeline.screenName = twitterlink!
                twittertimeline.isFromHome = true
                self.navigationController?.pushViewController(twittertimeline, animated: false)
            }
            else
            {
                let twitterview = self.storyboard?.instantiateViewController(withIdentifier: "TwitterViewController")
                self.navigationController?.pushViewController(twitterview!, animated: true)
            }
            
            
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
        //print("Menu was closed!")
        //flowmenu.contentImage = UIImage(named: "fab_more")
    }
    func loadTableData()
    {
        self.isValuePresent = self.newsAllData.isValuePresent
        if self.isValuePresent == true
        {
            self.newsarray = self.newsAllData.newsinfoArray
            if newsarray.count == 0
            {
                DispatchQueue.main.async {
                    self.spinner.stopAnimating()
                    self.Emptylabel.alpha = 1
                }
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.Emptylabel.alpha = 0
                    self.newsAllTable.reloadData()
                    if self.view.frame.origin.y >= 64
                    {
                        self.view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                        self.view.addSubview(self.flowmenu)
                        self.NewsAllTableViewTopConstraint.constant = 64
                        
                        
                    }
                    else
                    {
                        self.view.addSubview(self.flowmenu)
                    }
                    //self.flowmenu.hidden = true
                }
            }
            
            
        }
        /*
         dispatch_async(dispatch_get_main_queue()){
         
         for imgArray in self.newsarray
         {
         
         let img = imgArray.valueForKey("small_image") as! String
         let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
         let mainUrl:NSMutableString = NSMutableString(string: appDelegate.mainUrlString)
         
         
         mainUrl.appendString(img)
         let string = mainUrl
         var modifiedUrlString:NSString!
         // alternative: not case sensitive
         if string.lowercaseString.rangeOfString(".jpg") != nil {
         modifiedUrlString = (mainUrl as NSString).stringByReplacingOccurrencesOfString(".jpg", withString: "_s.jpg")
         }
         else if string.lowercaseString.rangeOfString(".png") != nil
         {
         modifiedUrlString = (mainUrl as NSString).stringByReplacingOccurrencesOfString(".png", withString: "_s.png")
         }
         else
         {
         modifiedUrlString = (mainUrl as NSString).stringByReplacingOccurrencesOfString(".jpeg", withString: "_s.jpeg")
         }
         
         let imgdata = NSData(contentsOfURL: NSURL(string: modifiedUrlString as String)!)
         let newsimg:UIImage = UIImage(data: imgdata!)!
         self.newsHomeImage = newsimg
         self.imgarray.append(self.newsHomeImage)
         
         //imgArray.addObject(self.newsHomeImage)
         }
         
         self.newsAllTable.reloadData()
         //self.animateTable()
         }*/
        //self.newsAllTable.reloadData()
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
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
        delay(0.6)
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
            let _ = self.navigationController?.popToRootViewController(animated: true)
        }
        //self.navigationController?.presentViewController(home, animated: true, completion: nil)
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
    override func viewDidLayoutSubviews() {
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isValuePresent != false
        {
            
            return newsarray.count
            
            
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.iPhone == true
        {
            return 80.0
        }
        if self.iPad == true
        {
            return 140.0
        }
        return 80.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:NewsAllCell!  = tableView.dequeueReusableCell(withIdentifier: CellnewsAllIdentifier) as! NewsAllCell//[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                cell.newsTitle.font = UIFont.systemFont(ofSize: 14)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 10)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                cell.newsTitle.font = UIFont.systemFont(ofSize: 16)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 12)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                cell.newsTitle.font = UIFont.systemFont(ofSize: 16)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 12)
                
            }
            if UIScreen.main.bounds.height == 736.0
            {
                cell.newsTitle.font = UIFont.systemFont(ofSize: 18)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 12)
            }
            
        }
        if self.iPad == true
        {
            cell.newsTitle.font = UIFont.systemFont(ofSize: 21)
            cell.newsDetail.font = UIFont.systemFont(ofSize: 18)
            if UIScreen.main.bounds.height == 1024.0
            {
                cell.newsTitle.font = UIFont.systemFont(ofSize: 21)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                cell.newsTitle.font = UIFont.systemFont(ofSize: 21)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                
                cell.newsTitle.font = UIFont.systemFont(ofSize: 21)
                cell.newsDetail.font = UIFont.systemFont(ofSize: 18)
            }
        }
        cell.newsTitle.text = (self.newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "title") as? String
        //cell.newsTitle.font = UIFont.systemFontOfSize(14)
        //cell.newsTitle.sizeToFit()
        let img = (self.newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "small_image") as! String
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let mainUrl:NSMutableString = NSMutableString(string: appDelegate.mainUrlString)
        
        
        mainUrl.append(img)
        let string = mainUrl
        var modifiedUrlString:NSString!
        // alternative: not case sensitive
        if string.lowercased.range(of: ".jpg") != nil {
            modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpg", with: "_s.jpg") as NSString!
        }
        else if string.lowercased.range(of: ".png") != nil
        {
            modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".png", with: "_s.png") as NSString!
        }
        else
        {
            modifiedUrlString = (mainUrl as NSString).replacingOccurrences(of: ".jpeg", with: "_s.jpeg") as NSString!
        }
        
        cell.newsHomeImageView.image = nil
        let imgURL = URL(string: modifiedUrlString as String)
        let request: URLRequest = URLRequest(url: imgURL!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let error = error
            let data = data
            self.spinner.stopAnimating()
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                
                // Store the image in to our cache
                //cell.newsHomeImageView.image = image
                // Update the cell
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    if let currentcell:NewsAllCell = cell {
                        
                        //Do UI stuff here
                        
                        currentcell.newsHomeImageView.image = image
                        
                        
                    }
                }
            }
        })
        task.resume()
        //cell.newsHomeImageView.image = imgarray[indexPath.row]
        
        
        //cell.newsHomeImageView.contentMode = .ScaleAspectFit
        //cell.newsDetail.numberOfLines = 2
        cell.newsDetail.text = (self.newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "descriptn") as? String
        cell.newsDetail.sizeToFit()
        var lineView:UIView!
        if self.iPhone == true
        {
             lineView = UIView(frame: CGRect(x: 0,y: 79, width: UIScreen.main.bounds.size.width, height: 1))
        }
        if self.iPad == true
        {
             lineView = UIView(frame: CGRect(x: 0,y: 139, width: UIScreen.main.bounds.size.width, height: 1))
        }
        // Configure the cell...
        
        lineView.backgroundColor = UIColor(hex:0xE4E3E3)
        cell.contentView.addSubview(lineView)
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.parent?.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            self.parent?.hideSideMenuView()
        }
        else
        {
            let cell:NewsAllCell  = tableView.cellForRow(at: indexPath) as! NewsAllCell
            let popupView = self.storyboard?.instantiateViewController(withIdentifier: "NewsPopupViewcontroller") as? NewsPopupViewcontroller
            popupView!.modalPresentationStyle = .overFullScreen
            //popupView?.delegate = self
            //loginView!.preferredContentSize = CGSizeMake(50, 100)
            popupView?.newsTitleString = cell.newsTitle.text
            popupView?.newsDescriptionString = cell.newsDetail.text
            var reportString:String!
            reportString = "Dated: "
            reportString = reportString.appendingFormat("%@", (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String) //appending((newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String)
            reportString = reportString.appending(", ")
            reportString = reportString.appendingFormat("%@", (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as! String)
            popupView?.newsReportString = reportString
            popupView?.imageString = (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "large_image") as! String
            let weburl = (newsarray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "websiteurl") as! String
            if weburl != ""
            {
                popupView?.weburlString = weburl
            }
            else
            {
                popupView?.weburlString = ""
            }
            let popoverMenuViewController = popupView!.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = .any
            popoverMenuViewController?.delegate = self
            self.view.window!.rootViewController!.present(popupView!,animated: true,completion: nil)
        }
    }
    
}
