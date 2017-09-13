//
//  TwitterViewController.swift
//  mConnect
//
//  Created by chipsy services on 17/10/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import QuartzCore
class TwitterViewController: UIViewController,ENSideMenuDelegate,PathMenuDelegate,UITableViewDelegate,UITableViewDataSource {
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var twitterData:TwitterInfoDataController!
    var twitterImage:UIImage!
    var spinner:SARMaterialDesignSpinner!
    var flowmenu:PathMenu!
    var bigimagearray:[UIImage]! = []
    var smallimgarray:[UIImage]! = []
    var TwitterArray:NSArray! = NSArray()
    var reachable:Reachability!
    var Emptylabel:UILabel!
    @IBOutlet var twitterTable: UITableView!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override func awakeFromNib() {
        
    }
    override func viewDidLoad() {
        reachable = Reachability()
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.Emptylabel = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-(50/2), width: UIScreen.main.bounds.width, height: 50))
            self.Emptylabel.textColor = UIColor.black
            self.Emptylabel.numberOfLines = 3
            self.Emptylabel.font = UIFont.systemFont(ofSize: 18)
            self.Emptylabel.textAlignment = .center
            self.Emptylabel.text = "There are no twitter profiles at this movement. Please check back later…"
            self.view.addSubview(self.Emptylabel)
            self.view.bringSubview(toFront: self.Emptylabel)
            self.Emptylabel.alpha = 0
        }
        if reachable.isReachable == true {
            //print("Internet connection OK")
            
            
            twitterData = TwitterInfoDataController()
            self.spinner = SARMaterialDesignSpinner(frame: CGRect(x: self.view.frame.width/2 - 25,y: (self.view.frame.height)/2 - 25,width: 50,height: 50))
            self.view.addSubview(self.spinner)
            spinner.strokeColor =  UIColor.blue
            
            spinner.startAnimating()
            
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
        }
        else
        {
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
        
        twitterTable.delegate = self
        twitterTable.dataSource = self
        self.navigationItem.title = "Twitter Feeds"
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTableData),name:NSNotification.Name(rawValue: "twitterdataReady"), object: nil)
        self.view.addSubview(self.flowmenu)
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
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
    func pathMenu(_ menu: PathMenu, didSelectIndex idx: Int) {
        //print("Select the index : \(idx)")
        if idx == 0
        {
            flowmenu.handleTap()
            //NSNotificationCenter.defaultCenter().postNotificationName("reloadFbSelected", object: self, userInfo: nil)
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
            
            flowmenu.contentImage = UIImage(named: "fab_more")
        }
        else if idx == 1
        {
            flowmenu.handleTap()
            
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
            let newsview = self.storyboard?.instantiateViewController(withIdentifier: "NewsAllViewController")
            self.navigationController?.pushViewController(newsview!, animated: true)
        }
        else
        {
            flowmenu.contentImage = UIImage(named: "fab_more")
            
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
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    func loadTableData()
    {
        DispatchQueue.main.async{
            self.TwitterArray = self.twitterData.twitterArray
            if self.twitterData.twitterArray.count == 0
            {
                DispatchQueue.main.async {
                    self.view.bringSubview(toFront: self.Emptylabel)
                    self.Emptylabel.alpha = 1
                    self.spinner.stopAnimating()
                }
                
            }
            else
            {
                DispatchQueue.main.async {
                    self.Emptylabel.alpha = 0
                    if self.twitterData.twitterArray.count == 1
                    {
                        let twitterlink = (self.TwitterArray[0] as AnyObject).value(forKey: "link") as? String
                        
                        let twittertimeline = self.storyboard?.instantiateViewController(withIdentifier: "TwitterTimelineTableViewController") as! TwitterTimelineTableViewController
                        twittertimeline.isFromHome = true
                        //facebkweb.request = request
                        twittertimeline.screenName = twitterlink
                        self.navigationController?.pushViewController(twittertimeline, animated: false)
                    }
                    else
                    {
                        
                        self.twitterTable.reloadData()
                        self.spinner.stopAnimating()
                    }
                }
                
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
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1, execute: closure)
    }
     func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return TwitterArray.count
    }
     func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.iPhone == true
        {
            return 150.0
        }
        if self.iPad == true
        {
            return 200.0
        }
        return 150.0
    }
     func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TwitterItemCell! = tableView.dequeueReusableCell(withIdentifier: "TwitterCell") as! TwitterItemCell
        cell.cellBlueFbTitle.text = (self.TwitterArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "desc") as? String
        cell.cellWhiteFbTitle.text = (self.TwitterArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "title") as? String
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 12)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 14)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 16)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 15)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 17)
                
            }
            if UIScreen.main.bounds.height == 736.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 16)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 18)
            }
            
        }
        if self.iPad == true
        {
            cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 12)
            cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 14)
            if UIScreen.main.bounds.height == 1024.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 12)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 12)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                cell.cellBlueFbTitle.font = UIFont.systemFont(ofSize: 12)
                cell.cellWhiteFbTitle.font = UIFont.systemFont(ofSize: 14)
            }
        }
        let img = (self.TwitterArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "imagepath") as! String
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
        
        cell.cellCircleImage.image = nil
        let imgURL = URL(string: modifiedUrlString as String)
        let request: URLRequest = URLRequest(url: imgURL!)
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            let error = error
            let data = data
            //self.spinner.stopAnimating()
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                
                // Store the image in to our cache
                //cell.newsHomeImageView.image = image
                // Update the cell
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    if let currentcell:TwitterItemCell = cell {
                        
                        //Do UI stuff here
                        
                        currentcell.cellCircleImage.image = image
                        
                        
                    }
                }
            }
        })
        task.resume()
        
        
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
        
        cell.cellbackgroundImage.image = nil
        let bigimgURL = URL(string: modifiedUrlString as String)
        let bigrequest: URLRequest = URLRequest(url: bigimgURL!)
        let bigsession = URLSession.shared
        let bigtask = bigsession.dataTask(with: bigrequest, completionHandler: {data, response, error -> Void in
            let error = error
            let data = data
            //self.spinner.stopAnimating()
            if error == nil {
                // Convert the downloaded data in to a UIImage object
                
                // Store the image in to our cache
                //cell.newsHomeImageView.image = image
                // Update the cell
                DispatchQueue.main.async {
                    let image = UIImage(data: data!)
                    if let currentcell:TwitterItemCell = cell {
                        
                        //Do UI stuff here
                        
                        currentcell.cellbackgroundImage.image = image
                        
                        
                    }
                }
            }
        })
        bigtask.resume()
        
        //cell.cellbackgroundImage.image = bigimagearray[indexPath.row]
        /* let gradientLayer : CAGradientLayer = CAGradientLayer();
         gradientLayer.frame = CGRectMake(0, 0, self.view.frame.width - 20, cell.gradientView.frame.height)
         gradientLayer.colors = [UIColor.clearColor().CGColor, UIColor.blackColor().CGColor];
         gradientLayer.startPoint = CGPointMake(0.5, 0.0);
         gradientLayer.endPoint = CGPointMake(0.5, 1.0)
         gradientLayer.opacity = 0.8;
         cell.gradientView.layer.insertSublayer(gradientLayer, atIndex: 0);
         */
        cell.cellInsideView.addCellShadowToView(cell.cellInsideView)
        //cell.cellCircleImage.image = smallimgarray[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            hideSideMenuView()
        }
        else
        {
            let twitterlink = (self.TwitterArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "link") as? String
            
            let twittertimeline = self.storyboard?.instantiateViewController(withIdentifier: "TwitterTimelineTableViewController") as! TwitterTimelineTableViewController
            //facebkweb.request = request
            twittertimeline.screenName = twitterlink
            self.navigationController?.pushViewController(twittertimeline, animated: false)
        }
    }
}
