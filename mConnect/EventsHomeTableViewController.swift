//
//  EventsHomeTableViewController.swift
//  homeScreen
//
//  Created by chipsy services on 08/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
var CelleventIdentifier = "EventCell"
class EventsHomeTableViewController: UITableViewController,UIPopoverPresentationControllerDelegate,ENSideMenuDelegate {
    @IBOutlet var EventsHomeTable: UITableView!
    var eventTitleArray:NSArray! = NSArray()
    var eventDetailArray:NSArray! = NSArray()
    var homeData:HomeInfoDataController!
    var eventTimeArray:NSArray! = NSArray()
    var eventPlaceArray:NSArray! = NSArray()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sideMenuController()?.sideMenu?.delegate = self
        self.sideMenuController()?.sideMenu?.allowRightSwipe = true
        self.sideMenuController()?.sideMenu?.allowPanGesture = true
        self.sideMenuController()?.sideMenu?.allowLeftSwipe = true
        EventsHomeTable.delegate = self
        EventsHomeTable.dataSource = self
        self.EventsHomeTable.reloadData()
        
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventTitleArray.count
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80.0
    }
    override func viewDidLayoutSubviews() {
        self.tableView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(eventTitleArray.count*80 + 160))
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:EventHomeCell = tableView.dequeueReusableCell(withIdentifier: CelleventIdentifier) as! EventHomeCell
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
        
        
        let dateLabelDigit:UILabel  = UILabel(frame: CGRect(x: 25.0, y: 15.0, width: 50.0, height: 30.0))//[[UILabel alloc] initWithFrame:CGRectMake(25.0, 15.0, 50.0, 30.0)];
        dateLabelDigit.textColor = UIColor.white
        let evntdate = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String
        let evntday = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "day") as! String
        let eventtime = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as! String
        let eventplace = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "place") as! String
        var eventtimestring = eventtime
        if eventplace != ""
        {
            eventtimestring = eventtimestring + " @ "
            eventtimestring = eventtimestring + eventplace
        }
        
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
        
        dateLabelDigit.font = UIFont.systemFont(ofSize: 24)//[UIFont systemFontOfSize:24.0f ];
        dateLabelDigit.contentMode = .center
        CellSideView.addSubview(dateLabelDigit)
        
        let dateLabelName:UILabel  = UILabel(frame: CGRect(x: 10.0, y: 35.0, width: 60.0, height: 30.0))//[[UILabel alloc] initWithFrame:CGRectMake(10.0, 35.0, 60.0, 30.0)];
        dateLabelName.textColor = UIColor.white
        dateLabelName.text = evntday
        dateLabelName.textAlignment = .center
        dateLabelName.font = UIFont.systemFont(ofSize: 10)//[UIFont systemFontOfSize:11.0f ];
        CellSideView.addSubview(dateLabelName)
        
        let lineView  = UIView(frame: CGRect(x: 80,y: 79, width: UIScreen.main.bounds.size.width,height: 1))
        lineView.backgroundColor = UIColor(hex:0xE4E3E3)
        cell.contentView.addSubview(lineView)
        let lineSideView = UIView(frame: CGRect(x: 0,y: 79, width: 80, height: 1))//[[UIView alloc] initWithFrame:CGRectMake(0,79, 80, 1)];
        lineSideView.backgroundColor = UIColor(hex:0x0872C8)
        cell.contentView.addSubview(lineSideView)
        // Configure the cell...
        cell.EventTitle.text = eventTitleArray[(indexPath as NSIndexPath).row] as? String
        if #available(iOS 8.2, *) {
            cell.EventTime.font = UIFont.systemFont(ofSize: 10, weight: -2.0)
        } else {
            // Fallback on earlier versions
            cell.EventTime.font = UIFont.systemFont(ofSize: 10)
        }//[UIFont systemFontOfSize:10 weight:-2.0];
        cell.EventTime.text = eventtimestring
        cell.EventTime.sizeToFit()
        return cell
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
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.parent?.sideMenuController()?.sideMenu?.isMenuOpen == true
        {
            self.parent?.hideSideMenuView()
        }
        else
        {
            let cell:EventHomeCell  = tableView.cellForRow(at: indexPath) as! EventHomeCell
            let popupView = self.storyboard?.instantiateViewController(withIdentifier: "EventPopUpViewController") as? EventPopUpViewController
            popupView!.modalPresentationStyle = .overFullScreen
            //popupView?.delegate = self
            //loginView!.preferredContentSize = CGSizeMake(50, 100)
            popupView?.eventTitleString = cell.EventTitle.text
            popupView?.eventDescriptionString = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "descriptn") as! String
            //popupView?.imageString = newsarray[indexPath.row].valueForKey("large_image") as! String
            let weburl = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "websiteurl") as! String
            if weburl != ""
            {
                popupView?.weburlString = weburl
            }
            else
            {
                popupView?.weburlString = ""
            }
            let events = self.homeData.eventsArray[(indexPath as NSIndexPath).row] as! EventsData
            popupView?.eventid = events.id
            let eventdate = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "date") as! String
            let eventtime = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "time") as! String
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
            popupView?.evntTime = eventtime
            popupView?.eventplace = (self.homeData.eventsArray[(indexPath as NSIndexPath).row] as AnyObject).value(forKey: "place") as! String
            switch(month)
            {
            case 1?:
                monthstring = "Jan"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 2?:
                monthstring = "Feb"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 3?:
                monthstring = "Mar"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 4?:
                monthstring = "Apr"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 5?:
                monthstring = "May"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 6?:
                monthstring = "Jun"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 7?:
                monthstring = "Jul"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 8?:
                monthstring = "Aug"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 9?:
                monthstring = "Sep"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 10?:
                monthstring = "Oct"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 11?:
                monthstring = "Nov"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            case 12?:
                monthstring = "Dec"
                datestring = self.newDateString(monthstring, day: day!, time: eventtime)
                popupView?.eventTimeString = datestring
                break
            default:
                break
                
            }
            popupView?.eventdate = eventdate
            let popoverMenuViewController = popupView!.popoverPresentationController
            popoverMenuViewController?.permittedArrowDirections = .any
            popoverMenuViewController?.delegate = self
            self.view.window!.rootViewController!.present(popupView!,animated: true,completion: nil)
        }
        //hideSideMenuView()
        
        
        
    }
}
