//
//  EventsAllViewController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 09/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import QuartzCore
var CelleventsAllIdentifier = "EventAllCell"
class EventsAllViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIPopoverPresentationControllerDelegate,ENSideMenuDelegate,EventOptionsViewControllerDelegate {
    
    var  menuButton:UIButton!
    var  menu:UIBarButtonItem!
    var isValuePresent:Bool! = false
    var prevsmonthString:String! = ""
    var spinner:SARMaterialDesignSpinner!
    var rowcount:Int! = 0
    var reachable:Reachability!
    var eventsEmptyLabel:UILabel!
    var sectnDataArray:[NSMutableArray]! = []
    var sectionEventsArray:NSMutableArray! = NSMutableArray()
    var sectionArray:NSMutableArray! = NSMutableArray()
    var sectionMonthArray:NSMutableArray! = NSMutableArray()
    var eventsData:EventsAllInfoDataController!
    var eventsarray:NSMutableArray! = NSMutableArray()
    var eventCategoryData:EventsCategoryDataController!
    var Emptylabel:UILabel!
    var iPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.phone
    }
    var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad
    }
    @IBOutlet var EventsAllTable: UITableView!
    override func viewDidLoad() {
        reachable = Reachability()
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.Emptylabel = UILabel(frame: CGRect(x: 0, y: (UIScreen.main.bounds.height/2)-(50/2), width: UIScreen.main.bounds.width, height: 50))
            self.Emptylabel.textColor = UIColor.black
            self.Emptylabel.numberOfLines = 3
            self.Emptylabel.font = UIFont.systemFont(ofSize: 18)
            self.Emptylabel.textAlignment = .center
            self.Emptylabel.text = "There are no Events at this moment. Please check back later…"
            self.view.addSubview(self.Emptylabel)
            self.view.bringSubview(toFront: self.Emptylabel)
            self.Emptylabel.alpha = 0
        }
        if reachable.isReachable == true {
            //print("Internet connection OK")
            
            
            eventsData = EventsAllInfoDataController()
            self.eventCategoryData = EventsCategoryDataController()
            self.spinner = SARMaterialDesignSpinner(frame: CGRect(x: self.view.frame.width/2 - 25,y: self.view.frame.height/2 - 25,width: 50,height: 50))
            self.view.addSubview(self.spinner)
            spinner.strokeColor =  UIColor.blue
            spinner.startAnimating()
        }
        else
        {
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
        EventsAllTable.delegate = self
        EventsAllTable.dataSource = self
        self.navigationItem.title = "Events"
        self.eventsEmptyLabel = UILabel(frame: CGRect(x: 0,y: self.view.frame.height / 2 ,width: self.view.frame.width,height: 80))
        self.eventsEmptyLabel.tag = 501
        self.eventsEmptyLabel.numberOfLines = 1
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 12)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 13)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 14)
                
            }
            if UIScreen.main.bounds.height == 736.0
            {
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 16)
            }
            
        }
        if self.iPad == true
        {
            self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 18)
            if UIScreen.main.bounds.height == 1024.0
            {
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                
                self.eventsEmptyLabel.font = UIFont.systemFont(ofSize: 18)
            }
        }
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
        NotificationCenter.default.addObserver(self, selector: #selector(self.loadTableData), name: NSNotification.Name(rawValue: "eventsAllDataReady"), object: nil)
    }
    override func viewDidAppear(_ animated: Bool) {
        
        
    }
    func loadTableData()
    {
        self.view.viewWithTag(501)?.removeFromSuperview()
        self.prevsmonthString = ""
        self.sectnDataArray = []
        self.rowcount = 0
        self.sectionArray = NSMutableArray()
        self.sectionEventsArray = NSMutableArray()
        if self.eventsData.eventsinfoArray.count == 0
        {
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.Emptylabel.alpha = 1
            }
        }
        else
        {
            DispatchQueue.main.async{
                self.Emptylabel.alpha = 0
            self.isValuePresent = self.eventsData.isValuePresent
            self.eventsarray = self.eventsData.eventsinfoArray
            
            for evnts in self.eventsarray
            {
                let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let currentdatecomponents = (calendar as NSCalendar).components([.month, .day, .year], from: Date())
                let (currentyear) = (currentdatecomponents.year)
                let eventdate = (evnts as AnyObject).value(forKey: "date") as! String
                let date = eventdate
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd-MM-yyyy"
                //dateFormatter.locale = NSLocale.currentLocale()
                // convert string into date
                //dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
                let dateValue:Date  =  dateFormatter.date(from: date)!
                //let greater = dateValue.timeIntervalSince1970 < NSDate().timeIntervalSince1970
                let evntcalendar = Calendar(identifier: Calendar.Identifier.gregorian)
                let components = (evntcalendar as NSCalendar).components([.month, .day, .year], from: dateValue)
                let month = components.month
                let year = components.year
                let monthstring:String!
                if year == currentyear
                {
                    monthstring = self.getMonthStringInfo(month!)
                    let sectiontitle = monthstring
                    let sectnmonth = self.sectionArray.lastObject as? String
                    if sectiontitle != sectnmonth
                    {
                        self.sectionArray.add(sectiontitle!)
                        if self.rowcount > 0
                        {
                            
                            
                            self.sectionEventsArray = NSMutableArray()
                            self.sectionMonthArray.add(self.rowcount)
                            self.rowcount = 1
                            self.sectionEventsArray.add(evnts)
                            if self.sectionEventsArray.count >= 1
                            {
                                self.sectnDataArray.append(self.sectionEventsArray)
                            }
                            
                        }
                        else
                        {
                            self.rowcount = 1
                            self.sectionEventsArray.add(evnts)
                            self.sectnDataArray.append(self.sectionEventsArray)
                        }
                    }
                    else
                    {
                        self.rowcount = self.rowcount + 1
                        self.sectionEventsArray.add(evnts)
                    }
                    
                    
                }
                else
                {
                    if self.prevsmonthString == ""
                    {
                        self.rowcount = 0
                        self.sectionEventsArray = NSMutableArray()
                    }
                    monthstring = self.getMonthStringInfo(month!)
                    if monthstring != self.prevsmonthString
                    {
                        self.prevsmonthString = monthstring
                        var sectiontitle = monthstring
                        sectiontitle = sectiontitle?.appendingFormat(" %i", year!)
                        self.sectionArray.add(sectiontitle!)
                        if self.rowcount > 0
                        {
                            self.sectionMonthArray.add(self.rowcount)
                            self.sectionEventsArray = NSMutableArray()
                            self.rowcount = 1
                            self.sectionEventsArray.add(evnts)
                            
                            if self.sectionEventsArray.count >= 1
                            {
                                self.sectnDataArray.append(self.sectionEventsArray)
                            }
                            
                            
                        }
                        else
                        {
                            self.rowcount = 1
                            self.sectionEventsArray.add(evnts)
                            self.sectnDataArray.append(self.sectionEventsArray)
                        }
                    }
                    else
                    {
                        self.rowcount = self.rowcount + 1
                        self.sectionEventsArray.add(evnts)
                        
                    }
                }
            }
            // if self.sectionEventsArray.count > 1
            //{
            //     self.sectnDataArray.append(self.sectionEventsArray)
            // }
            
            //self.sectionMonthArray.addObject(self.rowcount)
            self.spinner.stopAnimating()
            if self.sectionArray.count > 0
            {
                self.EventsAllTable.reloadData()
            }
            else
            {
                
            }
            
            //self.animateTable()
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
    func updateEvents(_ categoryid: Int, categoryName: String) {
        self.view.viewWithTag(501)?.removeFromSuperview()
        if categoryName != "All"
        {
            self.prevsmonthString = ""
            self.sectnDataArray = []
            self.rowcount = 0
            self.sectionArray = NSMutableArray()
            self.sectionEventsArray = NSMutableArray()
            DispatchQueue.main.async{
                self.isValuePresent = self.eventsData.isValuePresent
                self.eventsarray = self.eventsData.eventsinfoArray
                
                for evnts in self.eventsarray
                {
                    let currentevent = evnts as! EventsData
                    let evntcategoryid = currentevent.eventcategoryid
                    if evntcategoryid == categoryid
                    {
                        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
                        let currentdatecomponents = (calendar as NSCalendar).components([.month, .day, .year], from: Date())
                        let (currentyear) = (currentdatecomponents.year)
                        let eventdate = (evnts as AnyObject).value(forKey: "date") as! String
                        let date = eventdate
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        //dateFormatter.locale = NSLocale.currentLocale()
                        // convert string into date
                        //dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
                        let dateValue:Date  =  dateFormatter.date(from: date)!
                        //let greater = dateValue.timeIntervalSince1970 < NSDate().timeIntervalSince1970
                        let evntcalendar = Calendar(identifier: Calendar.Identifier.gregorian)
                        let components = (evntcalendar as NSCalendar).components([.month, .day, .year], from: dateValue)
                        let month = components.month
                        let year = components.year
                        let monthstring:String!
                        if year == currentyear
                        {
                            monthstring = self.getMonthStringInfo(month!)
                            let sectiontitle = monthstring
                            let sectnmonth = self.sectionArray.lastObject as? String
                            if sectiontitle != sectnmonth
                            {
                                self.sectionArray.add(sectiontitle!)
                                if self.rowcount > 0
                                {
                                    
                                    
                                    self.sectionEventsArray = NSMutableArray()
                                    self.sectionMonthArray.add(self.rowcount)
                                    self.rowcount = 1
                                    self.sectionEventsArray.add(evnts)
                                    if self.sectionEventsArray.count >= 1
                                    {
                                        self.sectnDataArray.append(self.sectionEventsArray)
                                    }
                                    
                                }
                                else
                                {
                                    self.rowcount = 1
                                    self.sectionEventsArray.add(evnts)
                                    self.sectnDataArray.append(self.sectionEventsArray)
                                }
                            }
                            else
                            {
                                self.rowcount = self.rowcount + 1
                                self.sectionEventsArray.add(evnts)
                            }
                            
                            
                        }
                        else
                        {
                            if self.prevsmonthString == ""
                            {
                                self.rowcount = 0
                                self.sectionEventsArray = NSMutableArray()
                            }
                            monthstring = self.getMonthStringInfo(month!)
                            if monthstring != self.prevsmonthString
                            {
                                self.prevsmonthString = monthstring
                                var sectiontitle = monthstring
                                sectiontitle = sectiontitle?.appendingFormat(" %i", year!)
                                self.sectionArray.add(sectiontitle!)
                                if self.rowcount > 0
                                {
                                    self.sectionMonthArray.add(self.rowcount)
                                    self.sectionEventsArray = NSMutableArray()
                                    self.rowcount = 1
                                    self.sectionEventsArray.add(evnts)
                                    
                                    if self.sectionEventsArray.count >= 1
                                    {
                                        self.sectnDataArray.append(self.sectionEventsArray)
                                    }
                                    
                                }
                                else
                                {
                                    self.rowcount = 1
                                    self.sectionEventsArray.add(evnts)
                                    self.sectnDataArray.append(self.sectionEventsArray)
                                }
                            }
                            else
                            {
                                self.rowcount = self.rowcount + 1
                                self.sectionEventsArray.add(evnts)
                                
                            }
                        }
                    }
                    
                }
                // if self.sectionEventsArray.count > 1
                //{
                //     self.sectnDataArray.append(self.sectionEventsArray)
                // }
                self.sectionMonthArray.add(self.rowcount)
                self.spinner.stopAnimating()
                if self.sectionArray.count > 0
                {
                    DispatchQueue.main.async{
                        
                        UIView.transition(with: self.EventsAllTable, duration: 0.5, options: [.transitionCrossDissolve], animations: {
                            self.EventsAllTable.reloadData()
                            }, completion: nil)
                    }
                }
                else
                {
                    self.isValuePresent = false
                    self.eventsEmptyLabel.textAlignment = .center
                    self.eventsEmptyLabel.text = "There are no events in category: "
                    self.eventsEmptyLabel.text = self.eventsEmptyLabel.text?.appendingFormat("%@", categoryName)
                    //self.eventsEmptyLabel.sizeToFit()
                    self.view.addSubview(self.eventsEmptyLabel)
                    
                    self.EventsAllTable.reloadData()
                    
                }
                
                //self.animateTable()
            }
        }
        else
        {
            self.loadTableData()
        }
    }
    func gotoHome()
    {
        //let home = self.storyboard?.instantiateViewControllerWithIdentifier("MyNavigationController") as! MyNavigationController
        hideSideMenuView()
        delay(0.6)
        {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reload"), object: self, userInfo: nil)
           let _ =  self.navigationController?.popToRootViewController(animated: true)
        }
        //self.navigationController?.presentViewController(home, animated: true, completion: nil)
    }
    func delay(_ delay: Double, closure: @escaping ()->()) {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC),
            execute: closure
        )
    }
    func menuButtonTouched(_ sender: AnyObject) {
        showSideMenuView()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.isValuePresent == true
        {
            return self.sectionArray.count
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isValuePresent == true
        {
            return (self.sectnDataArray[section].count )
        }
        else
        {
            return 0
        }
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45.0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    override func viewDidLayoutSubviews() {
        //self.tableView.contentSize = CGSizeMake(self.view.frame.width, CGFloat(eventsarray.count*80 + 160))
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventsAllCell = tableView.dequeueReusableCell(withIdentifier: CelleventsAllIdentifier) as! EventsAllCell
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 14)
                cell.EventTime.font = UIFont.systemFont(ofSize: 14)
            }
            if UIScreen.main.bounds.height == 568.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 16)
                cell.EventTime.font = UIFont.systemFont(ofSize: 12)
            }
            if UIScreen.main.bounds.height == 667.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 16)
                cell.EventTime.font = UIFont.systemFont(ofSize: 14)
                
            }
            if UIScreen.main.bounds.height == 736.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 18)
                cell.EventTime.font = UIFont.systemFont(ofSize: 16)
            }
            
        }
        if self.iPad == true
        {
            cell.EventTitle.font = UIFont.systemFont(ofSize: 20)
            cell.EventTime.font = UIFont.systemFont(ofSize: 18)
            if UIScreen.main.bounds.height == 1024.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 20)
                cell.EventTime.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 20)
                cell.EventTime.font = UIFont.systemFont(ofSize: 18)
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                cell.EventTitle.font = UIFont.systemFont(ofSize: 20)
                cell.EventTime.font = UIFont.systemFont(ofSize: 18)
                
            }
        }
        
        let CellSideViewFrame:CGRect  = CGRect(x: 0.0, y: 0.0, width: 80, height: 80)
        let CellSideView:UIView  = UIView(frame: CellSideViewFrame)//[[UIView alloc] initWithFrame:CellSideViewFrame];
        //let rightColor:UIColor  = UIColor(hex:0x509FF7)!
        //let leftColor:UIColor  = UIColor(hex:0x1986FF)!
        //let gradient:CAGradientLayer  = CAGradientLayer()
        //gradient.frame = CellSideView.frame
        //gradient.startPoint = CGPointMake(0, 0.5)
        //gradient.endPoint = CGPointMake(1.0, 0.5)
        //gradient.colors = [(leftColor.CGColor),(rightColor.CGColor)]
        //CellSideView.layer.insertSublayer(gradient, atIndex: 0)
        CellSideView.backgroundColor = UIColor(hex: 0x1986FF)
        cell.contentView.addSubview(CellSideView)
        let eventsArray = self.sectnDataArray[(indexPath as NSIndexPath).section]
        let evntday = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "day") as! String
        
        let eventplace = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "place") as! String
        let dateLabelDigit:UILabel  = UILabel(frame: CGRect(x: 25.0, y: 15.0, width: 50.0, height: 30.0))//[[UILabel alloc] initWithFrame:CGRectMake(25.0, 15.0, 50.0, 30.0)];
        dateLabelDigit.textColor = UIColor.white
        let evntdate = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String
        let eventtime = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as! String
        var eventtimestring = eventtime
        if eventplace != ""
        {
            eventtimestring = eventtimestring + " @ "
            eventtimestring = eventtimestring + eventplace
        }
        //eventtimestring = eventtimestring.stringByAppendingString(" @ ")
        //eventtimestring = eventtimestring.stringByAppendingString(eventplace)
        let date = evntdate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //dateFormatter.locale = NSLocale.currentLocale()
        // convert string into date
        //dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
        let dateValue:Date  =  dateFormatter.date(from: date)!
        //let greater = dateValue.timeIntervalSince1970 < NSDate().timeIntervalSince1970
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let components = (calendar as NSCalendar).components([.month, .day], from: dateValue)
        //let month = components.month
        
        let day = components.day
        dateLabelDigit.text = String(describing: day!)
        
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 24)//[UIFont systemFontOfSize:24.0f ];
            }
            if UIScreen.main.bounds.height == 568.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 26)//[UIFont systemFontOfSize:24.0f ];
            }
            if UIScreen.main.bounds.height == 667.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 26)//[UIFont systemFontOfSize:24.0f ];
            }
            if UIScreen.main.bounds.height == 736.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 27)//[UIFont systemFontOfSize:24.0f ];
            }
            
        }
        if self.iPad == true
        {
            dateLabelDigit.font = UIFont.systemFont(ofSize: 29)
            if UIScreen.main.bounds.height == 1024.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 29)//[UIFont systemFontOfSize:24.0f ];
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 29)//[UIFont systemFontOfSize:24.0f ];
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                dateLabelDigit.font = UIFont.systemFont(ofSize: 29)//[UIFont systemFontOfSize:24.0f ];
            }
        }
        
        
        dateLabelDigit.contentMode = .center
        CellSideView.addSubview(dateLabelDigit)
        
        let dateLabelName:UILabel  = UILabel(frame: CGRect(x: 10.0, y: 35.0, width: 60.0, height: 30.0))//[[UILabel alloc] initWithFrame:CGRectMake(10.0, 35.0, 60.0, 30.0)];
        dateLabelName.textColor = UIColor.white
        dateLabelName.text = evntday
        dateLabelName.textAlignment = .center
        if self.iPhone == true
        {
            if UIScreen.main.bounds.height == 480.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 10)//[UIFont systemFontOfSize:11.0f ];
            }
            if UIScreen.main.bounds.height == 568.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 12)//[UIFont systemFontOfSize:11.0f ];
            }
            if UIScreen.main.bounds.height == 667.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 13)//[UIFont systemFontOfSize:11.0f ];
                
            }
            if UIScreen.main.bounds.height == 736.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 14)//[UIFont systemFontOfSize:11.0f ];
            }
            
        }
        if self.iPad == true
        {
            dateLabelName.font = UIFont.systemFont(ofSize: 13)//[UIFont systemFontOfSize:11.0f ];
            if UIScreen.main.bounds.height == 1024.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 13)//[UIFont systemFontOfSize:11.0f ];
            }
            if UIScreen.main.bounds.height == 1366.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 13)//[UIFont systemFontOfSize:11.0f ];
            }
            if UIScreen.main.bounds.height == 1112.0
            {
                dateLabelName.font = UIFont.systemFont(ofSize: 13)//[UIFont systemFontOfSize:11.0f ];
                
            }
        }
        CellSideView.addSubview(dateLabelName)
        
        let lineView  = UIView(frame: CGRect(x: 80,y: 79, width: UIScreen.main.bounds.size.width,height: 1))
        lineView.backgroundColor = UIColor(hex:0xE4E3E3)
        cell.contentView.addSubview(lineView)
        let lineSideView = UIView(frame: CGRect(x: 0,y: 79, width: 80, height: 1))//[[UIView alloc] initWithFrame:CGRectMake(0,79, 80, 1)];
        lineSideView.backgroundColor = UIColor(hex:0x0872C8)
        cell.contentView.addSubview(lineSideView)
        // Configure the cell...
        cell.EventTitle.text = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "title") as? String
        if #available(iOS 8.2, *) {
            if self.iPhone == true
            {
                if UIScreen.main.bounds.height == 480.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 10, weight: -2.0)
                }
                if UIScreen.main.bounds.height == 568.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 12, weight: -2.0)
                }
                if UIScreen.main.bounds.height == 667.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 14, weight: -2.0)
                    
                }
                if UIScreen.main.bounds.height == 736.0
                {
                   cell.EventTime.font = UIFont.systemFont(ofSize: 16, weight: -2.0)
                }
                
            }
            if self.iPad == true
            {
                cell.EventTime.font = UIFont.systemFont(ofSize: 18, weight: -2.0)
                if UIScreen.main.bounds.height == 1024.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 18, weight: -2.0)
                }
                if UIScreen.main.bounds.height == 1366.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 18, weight: -2.0)
                }
                if UIScreen.main.bounds.height == 1112.0
                {
                    
                    cell.EventTime.font = UIFont.systemFont(ofSize: 18, weight: -2.0)
                }
            }
            
        } else {
            // Fallback on earlier versions
            
            if self.iPhone == true
            {
                if UIScreen.main.bounds.height == 480.0
                {
                   cell.EventTime.font = UIFont.systemFont(ofSize: 10)
                }
                if UIScreen.main.bounds.height == 568.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 12)
                }
                if UIScreen.main.bounds.height == 667.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 13)
                    
                }
                if UIScreen.main.bounds.height == 736.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 14)
                }
                
            }
            if self.iPad == true
            {
                cell.EventTime.font = UIFont.systemFont(ofSize: 16)
                if UIScreen.main.bounds.height == 1024.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 16)
                }
                if UIScreen.main.bounds.height == 1366.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 16)
                }
                if UIScreen.main.bounds.height == 1112.0
                {
                    cell.EventTime.font = UIFont.systemFont(ofSize: 16)
                }
            }
        }//[UIFont systemFontOfSize:10 weight:-2.0];
        cell.EventTime.text = eventtimestring
        cell.EventTime.sizeToFit()
        
        
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 35.0))
        let sectionTitleHeaderView = UIView(frame: CGRect(x: UIScreen.main.bounds.size.width/2 - 90, y: 5, width: 180, height: 35.0))
        sectionHeaderView.backgroundColor = UIColor(hex:0xEFEFF4)
        sectionTitleHeaderView.backgroundColor = UIColor(hex:0x509FF7)
        sectionTitleHeaderView.layer.cornerRadius = 2.0
        sectionHeaderView.addSubview(sectionTitleHeaderView)
        let headerLabel = UILabel(frame: CGRect(x: (sectionTitleHeaderView.frame.size.width/2) - 90, y: 5, width: 180, height: 25.0))
        headerLabel.backgroundColor = UIColor.clear
        headerLabel.textColor = UIColor.white
        headerLabel.textAlignment = .center
        headerLabel.font = UIFont.systemFont(ofSize: 16)
        sectionTitleHeaderView.addSubview(headerLabel)
        headerLabel.text = self.sectionArray[section] as? String
        headerLabel.text = headerLabel.text?.uppercased()
        return sectionHeaderView
    }
    func getMonthStringInfo(_ month:Int)->String
    {
        let monthstring:String!
        switch(month)
        {
        case 1:
            monthstring = "January"
            return monthstring
        case 2:
            monthstring = "February"
            return monthstring
        case 3:
            monthstring = "March"
            return monthstring
        case 4:
            monthstring = "April"
            return monthstring
        case 5:
            monthstring = "May"
            return monthstring
        case 6:
            monthstring = "June"
            return monthstring
        case 7:
            monthstring = "July"
            return monthstring
        case 8:
            monthstring = "August"
            return monthstring
        case 9:
            monthstring = "September"
            return monthstring
        case 10:
            monthstring = "October"
            return monthstring
        case 11:
            monthstring = "November"
            return monthstring
        case 12:
            monthstring = "December"
            return monthstring
        default:
            return ""
            
        }
    }
    func getMonthString(_ month:Int)->String
    {
        let monthstring:String!
        switch(month)
        {
        case 1:
            monthstring = "Jan"
            return monthstring
        case 2:
            monthstring = "Feb"
            return monthstring
        case 3:
            monthstring = "Mar"
            return monthstring
        case 4:
            monthstring = "Apr"
            return monthstring
        case 5:
            monthstring = "May"
            return monthstring
        case 6:
            monthstring = "Jun"
            return monthstring
        case 7:
            monthstring = "Jul"
            return monthstring
        case 8:
            monthstring = "Aug"
            return monthstring
        case 9:
            monthstring = "Sep"
            return monthstring
        case 10:
            monthstring = "Oct"
            return monthstring
        case 11:
            monthstring = "Nov"
            return monthstring
        case 12:
            monthstring = "Dec"
            return monthstring
        default:
            return ""
            
        }
        
    }
    
    @IBAction func categoryButtonClicked(_ sender: AnyObject) {
       if reachable.isReachable == true {
            //print("Internet connection OK")
            let popupView = self.storyboard?.instantiateViewController(withIdentifier: "EventOptionsViewController") as? EventOptionsViewController
            popupView!.modalPresentationStyle = .overFullScreen
            //popupView?.delegate = self
            //loginView!.preferredContentSize = CGSizeMake(50, 100)
            popupView?.delegate = self
            popupView?.eventCategoryData = self.eventCategoryData
            let popoverMenuViewController = popupView!.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = .any
            popoverMenuViewController?.delegate = self
            self.view.window!.rootViewController!.present(popupView!,animated: false,completion: nil)
        }
        else
        {
            DispatchQueue.main.async {
                self.loadAlert()
            }
        }
        
    }
    func newDateString(_ month:String,day:Int,time:String)-> String
    {
        var datestring = NSMutableString()
        datestring = NSMutableString(string: String(month))
        datestring.append(" ")
        datestring.append(String(day))
        datestring.append(", ")
        datestring.append(time)
        return datestring as String
    }
    func newDateAndMonthString(_ month:String,day:Int)-> String
    {
        var datestring = NSMutableString()
        datestring = NSMutableString(string: String(month))
        datestring.append(" ")
        datestring.append(String(day))
        return datestring as String
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.parent?.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            self.parent?.hideSideMenuView()
        }
        else
        {
            let cell:EventsAllCell  = tableView.cellForRow(at: indexPath) as! EventsAllCell
            let popupView = self.storyboard?.instantiateViewController(withIdentifier: "EventPopUpViewController") as? EventPopUpViewController
            popupView!.modalPresentationStyle = .overFullScreen
            //popupView?.delegate = self
            //loginView!.preferredContentSize = CGSizeMake(50, 100)
            popupView?.eventTitleString = cell.EventTitle.text
            let eventsArray = self.sectnDataArray[(indexPath as NSIndexPath).section]
            popupView?.eventDescriptionString = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "descriptn") as! String
            //popupView?.imageString = newsarray[indexPath.row].valueForKey("large_image") as! String
            let weburl = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "websiteurl") as! String
            if weburl != ""
            {
                popupView?.weburlString = weburl
            }
            else
            {
                popupView?.weburlString = ""
            }
            let events = eventsArray[(indexPath as NSIndexPath).row] as! EventsData
            popupView?.eventid = events.id
            //popupView?.eventid = self.eventsarray[indexPath.row].valueForKey("id") as! Int
            let eventdate = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String
            let eventtime = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as! String
            let eventenddate  = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "edate") as! String
            let eventendtime = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "etime") as! String
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
            var datestring:String!
            monthstring = self.getMonthString(month!)
            
            
            let eventdata:EventsData = eventsArray[(indexPath as NSIndexPath).row] as! EventsData
            if eventdata.wholeday == false
            {
                popupView?.wholeDayEvent = false
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                datestring = datestring.appending(" - ")
                datestring = datestring.appendingFormat("%@", (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "endtime") as! String)
                popupView?.eventTimeString = datestring
            }
            else
            {
                popupView?.wholeDayEvent = true
                datestring = self.newDateAndMonthString(monthstring, day: day!)
                datestring = datestring.appending(", Whole day")
                popupView?.eventTimeString = datestring
                
            }
            popupView?.evntTime = eventtime
            popupView?.eventdate = eventdate
            
            popupView?.eventenddate = eventenddate
            popupView?.eventendTime = eventendtime
            popupView?.eventplace = (eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "place") as! String
            let popoverMenuViewController = popupView!.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = .any
            popoverMenuViewController?.delegate = self
            self.view.window!.rootViewController!.present(popupView!,animated: true,completion: nil)
        }
        
    }
}
