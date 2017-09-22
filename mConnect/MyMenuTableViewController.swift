//
//  MyMenuTableViewController.swift
//  SwiftSideMenu
//
//  Created by Evgeny Nazarov on 29.09.14.
//  Copyright (c) 2014 Evgeny Nazarov. All rights reserved.
//

import UIKit

class MyMenuTableViewController: UITableViewController,UIPopoverPresentationControllerDelegate {
    var selectedMenuItem : Int = 0
    var gradient:CAGradientLayer!
    var eventImage:UIImage!
    var newsImage:UIImage!
    var facebookImage:UIImage!
    var twitterImage:UIImage!
    var emergencyImage:UIImage!
    var councilImage:UIImage!
    var youTubeImage:UIImage!
    var iseventOpened:Bool! = false
    var isnewsOpened:Bool! = false
    var isfacebookOpened:Bool! = false
    var istwitterOpened:Bool! = false
    var isyoutubrOpende:Bool! = false
    var isemergencyOpened:Bool! = false
    var iscouncilOpened:Bool! = false
    var isprivacyOpened:Bool! = false
    var isTermsOpened:Bool! = false
    var isContactOpened:Bool! = false
    var facebookCount:Int? = 0
    var twitterCount:Int? = 0
    
    var fblink:String?
    var twitterlink:String?
    var AppDelegateData:AppDelegate!
    @IBOutlet weak var ConnectingComunityLabel: UILabel!
    
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                 ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 12)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                
                 ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 736.0
            {
                 ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 18)
            }
            
        }
        if self.iPad == true
        {
             ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 18)
            if UIScreen.main.bounds.height == 1024.0
            {
                 ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                 ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                
                 ConnectingComunityLabel.font = UIFont.systemFont(ofSize: 18)
            }
        }

        eventImage = self.setnewImage(UIImage(named: "nvd_event")!)
        newsImage = self.setnewImage(UIImage(named: "nvd_news")!)
        facebookImage = self.setnewImage(UIImage(named: "nvd_fb")!)
        twitterImage = self.setnewImage(UIImage(named: "nvd_tweet")!)
        youTubeImage = self.setnewImage(UIImage(named: "you")!)
        emergencyImage = self.setnewImage(UIImage(named: "nvd_emr")!)
        councilImage = self.setnewImage(UIImage(named: "nvd_co")!)
        
        //<color name="clr_nav_right">#6F1412</color>
       // <color name="clr_nav_middle">#C02221</color>
       // <color name="clr_nav_left">#9F1D1D</color>
        
        
        // Customize apperance of table view
        //tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0) //
        //let y = UIScreen.mainScreen().bounds.height - UIScreen.mainScreen().bounds.height * 0.75
        //let edgeInsets = UIEdgeInsetsMake(y, 0, 0, 0)
        //self.tableView.contentInset = edgeInsets
        //self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        tableView.separatorStyle = .none
        let rightColor = UIColor(hex: 0x6F1412)
        let middleColor = UIColor(hex: 0xC02222)
        let leftColor = UIColor(hex: 0x9F1D1D)
        gradient = CAGradientLayer()
        gradient.frame = self.tableView.frame
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        gradient.colors = [(leftColor?.cgColor)!,(middleColor?.cgColor)!,(rightColor?.cgColor)!]
        gradient.locations = [0, 0.4, 1]
        //self.tableView.layer.insertSublayer(gradient, atIndex: 0)
        //self.view.layer.insertSublayer(gradient, atIndex: 0)
        //self.view.backgroundColor = UIColor.clearColor()
        //tableView.backgroundColor = UIColor(red: 38/255, green: 35/255, blue: 33/255, alpha: 1.0)
        tableView.scrollsToTop = false
        self.tableView.bounces = false
        self.clearsSelectionOnViewWillAppear = true
        
        //tableView.selectRowAtIndexPath(NSIndexPath(forRow: selectedMenuItem, inSection: 0), animated: false, scrollPosition: .Middle)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableData(_:)), name: NSNotification.Name(rawValue: "reload"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableFbSelected(_:)), name: NSNotification.Name(rawValue: "reloadFbSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableNewsSelected(_:)), name: NSNotification.Name(rawValue: "reloadNewsSelected"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableTwitterSelected(_:)), name: NSNotification.Name(rawValue: "reloadTwitterSelected"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableYoutubeSelected(_:)), name: NSNotification.Name(rawValue: "reloadTableYoutubeSelected"), object: nil)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableFacebookCount(_:)), name: NSNotification.Name(rawValue: "reloadFacebookCount"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadTableTwitterCount(_:)), name: NSNotification.Name(rawValue: "reloadTwitterCount"), object: nil)
        AppDelegateData = UIApplication.shared.delegate as! AppDelegate!
        
    }
    func setnewImage(_ img:UIImage)-> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
        img.draw(in: rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        
        context.setFillColor(UIColor.lightGray.cgColor);
        context.fill(rect);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage
    }
    func setcolorImage(_ img:UIImage)-> UIImage
    {
    let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
    UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
    img.draw(in: rect)
    
    let context:CGContext = UIGraphicsGetCurrentContext()!
    context.setBlendMode(CGBlendMode.sourceIn)
    //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
    
    context.setFillColor(UIColor(hex:0x3F51B5)!.cgColor);
    context.fill(rect);
    
    let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
    UIGraphicsEndImageContext()
    return newImage
    }
    func reloadTableData(_ notification: Notification) {
        DispatchQueue.main.async {
             self.iseventOpened = false
             self.isnewsOpened = false
             self.isfacebookOpened = false
             self.istwitterOpened = false
            self.isyoutubrOpende = false
             self.isemergencyOpened = false
             self.iscouncilOpened = false
            self.isContactOpened = false
            self.tableView.reloadData()
        }
        
    }
    func reloadTableFbSelected(_ notification:Notification){
        DispatchQueue.main.async {
            self.iseventOpened = false
            self.isnewsOpened = false
            self.isfacebookOpened = true
            self.istwitterOpened = false
            self.isyoutubrOpende = false
            self.isemergencyOpened = false
            self.iscouncilOpened = false
            self.isContactOpened = false
            self.tableView.reloadData()
        }
    }
    func reloadTableNewsSelected(_ notification:Notification){
        DispatchQueue.main.async {
            self.iseventOpened = false
            self.isnewsOpened = true
            self.isfacebookOpened = false
            self.istwitterOpened = false
            self.isyoutubrOpende = false
            self.isemergencyOpened = false
            self.iscouncilOpened = false
            self.isContactOpened = false
            self.tableView.reloadData()
        }
    }
    func reloadTableTwitterSelected(_ notification:Notification){
        DispatchQueue.main.async {
            self.iseventOpened = false
            self.isnewsOpened = false
            self.isfacebookOpened = false
            self.istwitterOpened = true
            self.isyoutubrOpende = false
            self.isemergencyOpened = false
            self.iscouncilOpened = false
            self.isContactOpened = false
            self.tableView.reloadData()
        }
    }
    func reloadTableYoutubeSelected(_ notification:Notification){
        DispatchQueue.main.async {
            self.iseventOpened = false
            self.isnewsOpened = false
            self.isfacebookOpened = false
            self.istwitterOpened = false
            self.isyoutubrOpende = true
            self.isemergencyOpened = false
            self.iscouncilOpened = false
            self.isContactOpened = false
            self.tableView.reloadData()
        }
    }
    func reloadTableFacebookCount(_ notification:Notification){
        DispatchQueue.main.async {
            let userInfo = notification.userInfo! as [AnyHashable : Any]
            self.facebookCount = userInfo["number"] as? Int
            self.fblink = userInfo["link"] as? String
            self.tableView.reloadData()
        }
    }
    func reloadTableTwitterCount(_ notification:Notification){
        DispatchQueue.main.async {
            let userInfo = notification.userInfo! as [AnyHashable : Any]
            self.twitterCount = userInfo["number"] as? Int
            self.twitterlink = userInfo["link"] as? String
            self.tableView.reloadData()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if section == 0
        {
           return 7
        }
        else
        {
            return 3
        }
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MenuItemCell = tableView.dequeueReusableCell(withIdentifier: "CELL") as! MenuItemCell
        //cell.selectionStyle = .None
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 12)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 736.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 14)
            }
            
        }
        if self.iPad == true
        {
            cell.menuItemLabel.font = UIFont.systemFont(ofSize: 18)
            if UIScreen.main.bounds.height == 1024.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                cell.menuItemLabel.font = UIFont.systemFont(ofSize: 18)
            }
        }
        cell.backgroundColor = UIColor.clear
        cell.textLabel?.textColor = UIColor.white
        if (indexPath as NSIndexPath).section == 0
        {
            if self.iPad == true
            {
                cell.imageTopSpace.constant = 27
                cell.imageBottomSpace.constant = 28
                cell.menuItemTitleTopSpace.constant = 27
                cell.menuItemTitleBottomSpace.constant = 28
            }
            switch ((indexPath as NSIndexPath).row) {
            case 0:
                if iseventOpened == true
                {
                    eventImage = self.setcolorImage(UIImage(named: "nvd_event")!)
                    cell.menuItemIconImageview.image = eventImage
                    cell.menuItemLabel?.text = "Events"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                }
                else
                {
                    eventImage = self.setnewImage(UIImage(named: "nvd_event")!)
                    cell.menuItemIconImageview.image = eventImage
                    cell.menuItemLabel?.text = "Events"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
            case 1:
                if isnewsOpened == true
                {
                    newsImage = self.setcolorImage(UIImage(named: "nvd_news")!)
                    cell.menuItemIconImageview.image = newsImage
                    cell.menuItemLabel?.text = "News"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                }
                else
                {
                    newsImage = self.setnewImage(UIImage(named: "nvd_news")!)
                    cell.menuItemIconImageview.image = newsImage
                    cell.menuItemLabel?.text = "News"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
            case 2:
                if isfacebookOpened == true
                {
                    facebookImage = self.setcolorImage(UIImage(named: "nvd_fb")!)
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemIconImageview.image = facebookImage
                    cell.menuItemLabel?.text = "Facebook"
                }
                else
                {
                    facebookImage = self.setnewImage(UIImage(named: "nvd_fb")!)
                    cell.menuItemIconImageview.image = facebookImage
                    cell.menuItemLabel?.text = "Facebook"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
            case 3:
                if istwitterOpened == true
                {
                    twitterImage = self.setcolorImage(UIImage(named: "nvd_tweet")!)
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemIconImageview.image = twitterImage
                    cell.menuItemLabel?.text = "Twitter"
                }
                else
                {
                    twitterImage = self.setnewImage(UIImage(named: "nvd_tweet")!)
                    cell.menuItemIconImageview.image = twitterImage
                    cell.menuItemLabel?.text = "Twitter"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
            case 4:
                if isyoutubrOpende == true
                {
                    youTubeImage = self.setcolorImage(UIImage(named: "you")!)
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemIconImageview.image = youTubeImage
                    cell.menuItemLabel?.text = "YouTube"
                }
                else
                {
                    youTubeImage = self.setnewImage(UIImage(named: "you")!)
                    cell.menuItemIconImageview.image = youTubeImage
                    cell.menuItemLabel?.text = "YouTube"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
            case 5:
                if isemergencyOpened == true
                {
                    emergencyImage = self.setcolorImage(UIImage(named: "nvd_emr")!)
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemIconImageview.image = emergencyImage
                    cell.menuItemLabel?.text = "Important Numbers"
                }
                else
                {
                    emergencyImage = self.setnewImage(UIImage(named: "nvd_emr")!)
                    cell.menuItemIconImageview.image = emergencyImage
                    cell.menuItemLabel?.text = "Important Numbers"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
            case 6:
                if iscouncilOpened == true
                {
                    councilImage = self.setcolorImage(UIImage(named: "nvd_co")!)
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemIconImageview.image = councilImage
                    cell.menuItemLabel?.text = "Town Council"
                }
                else
                {
                    councilImage = self.setnewImage(UIImage(named: "nvd_co")!)
                    cell.menuItemIconImageview.image = councilImage
                    cell.menuItemLabel?.text = "Town Council"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                break
                
            default:
                //cell.textLabel?.text = ""
                break
            }
            
            
        }
        if (indexPath as NSIndexPath).section == 1
        {
            if self.iPad == true
            {
                cell.imageTopSpace.constant = 27
                cell.imageBottomSpace.constant = 28
                cell.menuItemTitleTopSpace.constant = 27
                cell.menuItemTitleBottomSpace.constant = 28
                
            }
            cell.menuImageLeadingSpace.constant = 0
            var frm = cell.menuItemIconImageview.frame
            frm = CGRect(x: 0, y: cell.menuItemIconImageview.frame.origin.y, width: 0, height: 0)
            cell.menuItemIconImageview.frame = frm
            cell.menuTitleLeading.constant = 10
            switch ((indexPath as NSIndexPath).row) {
            case 0:
                if isContactOpened == true
                {
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemLabel?.text = "Contact & Feedback"
                }
                else
                {
                    cell.menuItemLabel?.text = "Contact & Feedback"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                
                break
            case 1:
                if isprivacyOpened == true
                {
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemLabel?.text = "Privacy Policy"
                }
                else
                {
                    cell.menuItemLabel?.text = "Privacy Policy"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                }
                
                break
            case 2:
                if isTermsOpened == true
                {
                    cell.menuItemLabel.textColor = UIColor(hex: 0x3F51B5)
                    cell.menuItemLabel?.text = "Terms & Conditions"
                    
                }
                else
                {
                    cell.menuItemLabel?.text = "Terms & Conditions"
                    cell.menuItemLabel.textColor = UIColor(hex: 0x555555)
                    
                }
                
                break
            default:
                break
            }
        }
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 1
        {
            return 1.0
        }
        return 0.0
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
               return 40.0
            }
            if UIScreen.main.bounds.height == 568.0
            {
                return 45.0
            }
            if UIScreen.main.bounds.height == 667.0
            {
                
                return 50.0
            }
            if UIScreen.main.bounds.height == 736.0
            {
                return 57
            }
            
        }
        if self.iPad == true
        {
            
            if UIScreen.main.bounds.height == 1024.0
            {
                return 80.0
                
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                 return 80.0
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                 return 80.0
                
            }
            else
            {
                 return 80.0
            }
        }
        return 40.0
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let lineBottomView:UIView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.self.width, height: 1))
        lineBottomView.backgroundColor  = UIColor.lightGray
        return lineBottomView
    }
    func updateBadge() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "updateBadge"), object: self, userInfo: nil)
    }
    func loadLoginPopup() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "loadLogin"), object: self, userInfo: nil)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        sideMenuController()?.sideMenu?.toggleMenu()
        //Present new view controller
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main",bundle: nil)
        var destViewController : UIViewController
        if indexPath.section == 0
        {
            switch (indexPath.row) {
            case 0:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.iseventOpened = true
                self.isnewsOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "EventsAllViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                    delay(0.8)
                    {
                        if self.AppDelegateData.SelectedOption != "EventsAllViewController"
                        {
                            self.sideMenuController()?.setContentViewController(destViewController)
                        }
                        
                    }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
            case 1:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.isnewsOpened = true
                self.iseventOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "NewsAllViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                    delay(0.8)
                    {
                        if self.AppDelegateData.SelectedOption != "NewsAllViewController"
                        {
                            self.sideMenuController()?.setContentViewController(destViewController)
                        }
                    }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
            case 2:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.iseventOpened = false
                self.isnewsOpened = false
                self.isfacebookOpened = true
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                if self.facebookCount == 1
                {
                    let url:URL = URL(string: self.fblink!)!
                    let request = NSMutableURLRequest(url: url)
                    let destViewController = self.storyboard?.instantiateViewController(withIdentifier: "FacebookWebViewController") as! FacebookWebViewController
                    destViewController.request = request
                    destViewController.isFromHome = true
                    if sideMenuController()?.sideMenu?.isMenuOpen != true
                    {
                        
                        delay(0.8)
                        {
                            if self.AppDelegateData.SelectedOption != "FacebookWebViewController"
                            {
                            self.sideMenuController()?.setContentViewController(destViewController)
                            }
                        }
                        
                    }
                }
                else
                {
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "FacebookViewController")
                    if sideMenuController()?.sideMenu?.isMenuOpen != true
                    {
                        delay(0.8)
                        {
                            if self.AppDelegateData.SelectedOption != "FacebookViewController"
                            {
                            self.sideMenuController()?.setContentViewController(destViewController)
                            }
                        }
                    }
                }
                
                //pushViewController(destViewController, animated: true)
                
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
            case 3:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.iseventOpened = false
                self.isnewsOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = true
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
               
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                
                
                //pushViewController(destViewController, animated: true)
                if self.twitterCount == 1
                {
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "MoveToTwitterViewController")
                    //facebkweb.request = request
                    //destViewController.screenName = twitterlink!
                    let appDelegate = UIApplication.shared.delegate as! AppDelegate
                    appDelegate.twitterlink = self.twitterlink!
                    //destViewController.isFromHome = true
                    if sideMenuController()?.sideMenu?.isMenuOpen != true
                    {
                        
                        delay(0.8)
                        {
                            if self.AppDelegateData.SelectedOption != "MoveToTwitterViewController"
                            {
                            self.sideMenuController()?.setContentViewController(destViewController)
                            }
                        }
                        
                    }
                }
                else
                {
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "TwitterViewController")
                    if sideMenuController()?.sideMenu?.isMenuOpen != true
                    {
                        delay(0.8)
                        {
                            if self.AppDelegateData.SelectedOption != "TwitterViewController"
                            {
                            self.sideMenuController()?.setContentViewController(destViewController)
                            }
                        }
                    }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
                
            case 4:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.iseventOpened = false
                self.isnewsOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = true
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                
            
                

                if AppDelegateData.YouTubeArrayCountHome! > 1
                {
                    destViewController = mainStoryboard.instantiateViewController(withIdentifier: "YoutubeViewController")
                    if sideMenuController()?.sideMenu?.isMenuOpen != true
                    {
                        delay(0.8)
                        {
                            if self.AppDelegateData.SelectedOption != "YoutubeViewController"
                            {
                            self.sideMenuController()?.setContentViewController(destViewController)
                            }
                        }
                    }
                }
                else if AppDelegateData.YouTubeArrayCountHome == 1
                {
                    print(AppDelegateData.YouTubeArrayLinkHome!)
                    let appURL = NSURL(string: AppDelegateData.YouTubeArrayLinkHome!)!
                    let webURL = NSURL(string: AppDelegateData.YouTubeArrayLinkHome!)!
                    let application = UIApplication.shared
                    
                    self.tableView.reloadData()
                    if application.canOpenURL(appURL as URL) {
                        if #available(iOS 10.0, *) {
                            application.open(appURL as URL)
                        } else {
                            // Fallback on earlier versions
                        }
                    } else {
                        // if Youtube app is not installed, open URL inside Safari
                        if #available(iOS 10.0, *) {
                            application.open(webURL as URL)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                else if AppDelegateData.YouTubeArrayCountHome! == 0
                {
                    let YoutubeQuery =  "Your Query"
                    let escapedYoutubeQuery = YoutubeQuery.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
                    let appURL = NSURL(string: "https://www.youtube.com/user/TownofMorrisvilleNC")!
                    let webURL = NSURL(string: "https://www.youtube.com/user/TownofMorrisvilleNC")!
                    let application = UIApplication.shared
                    
                    self.tableView.reloadData()
                    if application.canOpenURL(appURL as URL) {
                        if #available(iOS 10.0, *) {
                            application.open(appURL as URL)
                        } else {
                            // Fallback on earlier versions
                        }
                    } else {
                        // if Youtube app is not installed, open URL inside Safari
                        if #available(iOS 10.0, *) {
                            application.open(webURL as URL)
                        } else {
                            // Fallback on earlier versions
                        }
                    }
                }
                
                self.tableView.reloadData()
                
                break
            case 5:
                self.isfacebookOpened = false
                self.iseventOpened = false
                self.isnewsOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = true
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "EmergencyNumberViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                    delay(0.8)
                    {
                        if self.AppDelegateData.SelectedOption != "EmergencyNumberViewController"
                        {
                        self.sideMenuController()?.setContentViewController(destViewController)
                        }
                    }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
            case 6:
                self.isfacebookOpened = false
                self.iseventOpened = false
                self.isnewsOpened = false
                
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = true
                self.isemergencyOpened = false
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "CouncilMemberViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                    delay(0.8)
                    {
                        if self.AppDelegateData.SelectedOption != "CouncilMemberViewController"
                        {
                        self.sideMenuController()?.setContentViewController(destViewController)
                        }
                    }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
            default:
                //destViewController = mainStoryboard.instantiateViewControllerWithIdentifier("TempleListTableViewController")
                break
            }
        }
        else
        {
            switch (indexPath.row) {
            case 0:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.iseventOpened = false
                self.isnewsOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = false
                self.isContactOpened = true
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "ContactViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                    delay(0.8)
                    {
                        
                        if self.AppDelegateData.SelectedOption != "ContactViewController"
                        {
                        self.sideMenuController()?.setContentViewController(destViewController)
                        }
                    }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                    self.tableView.remembersLastFocusedIndexPath = true
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                    // Fallback on earlier versions
                    self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                    
                }
                break
                case 1:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.iseventOpened = false
                self.isnewsOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                self.isContactOpened = false
                self.isprivacyOpened = true
                self.isTermsOpened = false
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "PrivacyPolicyViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                delay(0.8)
                {
                    if self.AppDelegateData.SelectedOption != "PrivacyPolicyViewController"
                    {
                self.sideMenuController()?.setContentViewController(destViewController)
                    }
                }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                self.tableView.remembersLastFocusedIndexPath = true
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                // Fallback on earlier versions
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                
                }
                break
         case 2:
                //tableView.deselectRowAtIndexPath(indexPath, animated: false)
                self.isnewsOpened = false
                self.iseventOpened = false
                self.isfacebookOpened = false
                self.istwitterOpened = false
                self.isyoutubrOpende = false
                self.iscouncilOpened = false
                self.isemergencyOpened = false
                self.isContactOpened = false
                self.isprivacyOpened = false
                self.isTermsOpened = true
                
                destViewController = mainStoryboard.instantiateViewController(withIdentifier: "TermsViewController")
                //pushViewController(destViewController, animated: true)
                if sideMenuController()?.sideMenu?.isMenuOpen != true
                {
                delay(0.8)
                {
                    if self.AppDelegateData.SelectedOption != "TermsViewController"
                    {
                self.sideMenuController()?.setContentViewController(destViewController)
                    }
                }
                }
                
                //self.tableView.beginUpdates()
                //self.tableView.endUpdates()
                
                self.tableView.reloadData()
                
                if #available(iOS 9.0, *) {
                self.tableView.remembersLastFocusedIndexPath = true
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                } else {
                // Fallback on earlier versions
                self.tableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
                
                }
                break
            default:
                break
            }
        }
        
        
    }
    

    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
