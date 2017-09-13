//
//  EventPopUpViewController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 01/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit
import QuartzCore
import EventKit
var localTimeZoneAbbreviation: String { return NSTimeZone.local.abbreviation(for: Date()) ?? ""}
    class EventPopUpViewController: UIViewController,UIScrollViewDelegate {
    var eventTitleString:String!
    var eventDescriptionString:String!
    var eventTimeString:String!
    var eventdate:String!
    var evntTime:String!
    
    var eventendTimeString:String!
    var eventenddate:String!
    var contentHeightDone:Bool! = false
    var eventendTime:String!
    var eventid:Int!
    var wholeDayEvent:Bool! = false
    var eventplace:String!
    var savedEventId : String = ""
    var weburlString:String!
    var eventidArray:NSMutableArray! = NSMutableArray()
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var eventPopScroll: UIScrollView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var eventTimeLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    @IBOutlet weak var remindLabel: UILabel!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var eventDescriptionLabel: UITextView!
    @IBOutlet weak var insideViewHeight: NSLayoutConstraint!
    @IBOutlet weak var contentViewHeight: NSLayoutConstraint!
    @IBOutlet weak var insideView: UIView!
    @IBOutlet weak var closeButtonBottomConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        self.eventidArray = appDelegate.eventidarray
        let reminddict = appDelegate.eventreminddict
        if reminddict?[eventid] != nil {
            let eventStore = EKEventStore()
            let val = reminddict?[eventid]
            if let existingEvent = eventStore.event(withIdentifier: val as! String)
            {
                self.remindLabel.text = "delete"
                //let val = reminddict[eventid]
                self.savedEventId = existingEvent.eventIdentifier
            }
            else
            {
                appDelegate.eventreminddict.removeObject(forKey: eventid)
                self.remindLabel.text = "remind me"
                
            }
            //[eventStore eventWithIdentifier:[[NSUserDefaults standardUserDefaults] objectForKey:self.showId]];
            
            // the key exists in the dictionary
        }
        else
        {
            self.remindLabel.text = "remind me"
        }
        UIView.animate(withDuration: 2.0, animations: {
            self.arrowImageView.transform = CGAffineTransform(rotationAngle: (90.0 * CGFloat(M_PI)) / 180.0)
        })
        self.eventPopScroll.delegate = self
        self.eventTitleLabel.text = eventTitleString
        self.eventTimeLabel.text = eventTimeString
        self.eventDescriptionLabel.text = eventDescriptionString
        let  attrbstr = weburlString
        //newspopScroll.delegate = self
        if attrbstr != ""
        {
            self.eventDescriptionLabel.text = self.eventDescriptionLabel.text?.appendingFormat("\n%@", attrbstr!)
        }
        self.eventDescriptionLabel.sizeToFit()
        shareButton.layer.cornerRadius = 15
        closeButton.layer.cornerRadius = 24
        let imgclose:UIImage = self.setclosecolorImage(UIImage(named: "close")!)
        closeButton.setImage(imgclose, for: UIControlState())
        closeButton.contentMode = .center
        closeButton.addDropShadowToView(closeButton)
        insideViewHeight.constant = self.eventDescriptionLabel.frame.height * 2 + 150
        if insideViewHeight.constant > contentViewHeight.constant
        {
            let newheight = contentViewHeight.constant - insideViewHeight.constant
            contentViewHeight.constant = contentViewHeight.constant + newheight
        }
        NotificationCenter.default.addObserver(self, selector: #selector(self.changeReminderLabel), name: NSNotification.Name(rawValue: "changereminderLabel"), object: nil)
        
    }
    func changeReminderLabel()
    {
        DispatchQueue.main.async
        {
            self.remindLabel.text = "remind me"
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    func loadAlert()
    {
        DispatchQueue.main.async {
            
            let alertController = UIAlertController (title: "", message: "You are not in EST Zone. You have to manually adjust this event time on your calendar.", preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            
            alertController.addAction(okAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    override func viewDidLayoutSubviews() {
        if insideViewHeight.constant < 380
        {
            contentViewHeight.constant = self.view.frame.height
            self.eventPopScroll.contentSize = CGSize(width: self.eventPopScroll.contentSize.width, height: self.view.frame.height)
            let aRect : CGRect = self.view.frame
            if let view = self.insideView {
                if (!aRect.contains(view.frame.origin)){
                    self.eventPopScroll.scrollRectToVisible(view.frame, animated: true)
                }
            }
            //insideView.frame.origin.y = 80.0
            //closeButtonBottomConstraint.constant = 6.0
        }
        else
        {
            if contentHeightDone != true
            {
                let newheight = contentViewHeight.constant - insideViewHeight.constant
                contentViewHeight.constant = contentViewHeight.constant + newheight
                contentHeightDone = true
                let aRect : CGRect = self.view.frame
                if let view = self.insideView {
                    if (!aRect.contains(view.frame.origin)){
                        self.eventPopScroll.scrollRectToVisible(view.frame, animated: true)
                    }
                }
                //insideView.frame.origin.y = 80.0
                //closeButtonBottomConstraint.constant = 6.0
                
            }
            
            //contentViewHeight.constant = self.view.frame.height - insideViewHeight.constant
            
        }
    }
    @IBAction func reminderButtonClicked(_ sender: AnyObject) {
        //You are not in EST Zone. You have to manually adjust this event time on your calendar.
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        //dateFormatter.locale = NSLocale.currentLocale()
        // convert string into date
        //dateFormatter.timeZone = NSTimeZone.systemTimeZone()
        let dateValue:Date  =  dateFormatter.date(from: eventdate)!
        
        //let greater = dateValue.timeIntervalSince1970 < NSDate().timeIntervalSince1970
        var calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone.current
        let components = (calendar as NSCalendar).components([.month, .day, .year], from: dateValue)
        //let dateAsString = evntTime
        //let dateFormater = NSDateFormatter()
        //dateFormater.dateFormat = "h:mm a"
        
        let inFormatter = DateFormatter()
        //inFormatter.timeZone = NSTimeZone.systemTimeZone()
        //inFormatter.locale = NSLocale.currentLocale()
        inFormatter.dateFormat = "hh:mm a"
        
        let outFormatter = DateFormatter()
        //outFormatter.locale = NSLocale.currentLocale()
        outFormatter.dateFormat = "hh:mm a"
        
        let inStr = evntTime
        let date = inFormatter.date(from: inStr!)!
        //let outStr = outFormatter.stringFromDate(date)
        
        //let date = dateFormatter.dateFromString(dateAsString)
        
        var timecalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        timecalendar.timeZone = TimeZone.autoupdatingCurrent
        let timecomponents = (timecalendar as NSCalendar).components([.hour,.minute, .second], from: date)
        
        let evntFormatter = DateFormatter()
        //evntFormatter.timeZone = NSTimeZone.systemTimeZone()
       // evntFormatter.locale = NSLocale.currentLocale()
        evntFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        
        var newcomponent = DateComponents()
        newcomponent.year = components.year
        newcomponent.month = components.month
        newcomponent.day = components.day
        newcomponent.hour = timecomponents.hour
        newcomponent.minute = timecomponents.minute
        newcomponent.second = timecomponents.second
        var newcompcalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        newcompcalendar.timeZone = TimeZone.current
        let evdate = newcompcalendar.date(from: newcomponent)
        let dtstring = evntFormatter.string(from: evdate!)
        let evntdate = evntFormatter.date(from: dtstring)
        
        
        let endDateValue:Date  =  dateFormatter.date(from: eventenddate)!
        
        //let greater = dateValue.timeIntervalSince1970 < NSDate().timeIntervalSince1970
        var endcalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        endcalendar.timeZone = TimeZone.current
        let endtcomponents = (endcalendar as NSCalendar).components([.month, .day, .year], from: endDateValue)
        //let dateAsString = evntTime
        //let dateFormater = NSDateFormatter()
        //dateFormater.dateFormat = "h:mm a"
        
        //let inFormatter = DateFormatter()
        //inFormatter.timeZone = NSTimeZone.systemTimeZone()
        //inFormatter.locale = NSLocale.currentLocale()
        //inFormatter.dateFormat = "hh:mm a"
        
        //let outFormatter = DateFormatter()
        //outFormatter.locale = NSLocale.currentLocale()
        //outFormatter.dateFormat = "hh:mm a"
        
        let endinStr = eventendTime
        let enddate = inFormatter.date(from: endinStr!)!
        //let outStr = outFormatter.stringFromDate(date)
        
        //let date = dateFormatter.dateFromString(dateAsString)
        
        var endtimecalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        endtimecalendar.timeZone = TimeZone.autoupdatingCurrent
        let endtimecomponents = (endtimecalendar as NSCalendar).components([.hour,.minute, .second], from: enddate)
        
        //let evntFormatter = DateFormatter()
        //evntFormatter.timeZone = NSTimeZone.systemTimeZone()
        // evntFormatter.locale = NSLocale.currentLocale()
        //evntFormatter.dateFormat = "MM-dd-yyyy hh:mm a"
        
        var newendcomponent = DateComponents()
        newendcomponent.year = endtcomponents.year
        newendcomponent.month = endtcomponents.month
        newendcomponent.day = endtcomponents.day
        newendcomponent.hour = endtimecomponents.hour
        newendcomponent.minute = endtimecomponents.minute
        newendcomponent.second = endtimecomponents.second
        var newendcompcalendar = Calendar(identifier: Calendar.Identifier.gregorian)
        newendcompcalendar.timeZone = TimeZone.current
        let evenddate = newendcompcalendar.date(from: newendcomponent)
        let enddtstring = evntFormatter.string(from: evenddate!)
        let endevntdate = evntFormatter.date(from: enddtstring)
        
        
        
        
        
        
        //let date_interval = evntdate?.timeIntervalSinceDate(NSDate())
        if remindLabel.text == "remind me"
        {
            if localTimeZoneAbbreviation != "EST"
            {
                if localTimeZoneAbbreviation != "EDT"
                {
                    self.loadAlert()
                }
                
            }
            let eventStore = EKEventStore()
            
            let startDate = evntdate //NSDate().dateByAddingTimeInterval(60*60*24.5)
            let endDate = endevntdate//startDate!.addingTimeInterval(60 * 60) // One hour
            
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: {
                    granted, error in
                    if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized)
                    {
                        let alertController = UIAlertController(title: "mConnect",
                            message: "The calendar permission was not authorized. Please enable it in Settings to continue.",
                            preferredStyle: .alert)
                        
                        let settingsAction = UIAlertAction(title: "Settings", style: .default) { (alertAction) in
                            
                            // THIS IS WHERE THE MAGIC HAPPENS!!!!
                            
                            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                                DispatchQueue.main.async
                                {
                                    //self.dismissViewControllerAnimated(false, completion: nil)
                                    UIApplication.shared.openURL(appSettings) 
                                }
                                
                            }
                        }
                        alertController.addAction(settingsAction)
                        
                        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                        alertController.addAction(cancelAction)
                        DispatchQueue.main.async
                        {
                            self.present(alertController, animated: true, completion: nil)
                        }
                        
                    }
                    else
                    {
                        self.createEvent(eventStore, title: self.eventTitleString, startDate: startDate!, endDate: endDate!,notes: self.eventDescriptionString)
                        DispatchQueue.main.async
                        {
                            self.remindLabel.text = "delete"
                        }
                    }
                    
                    //self.remindLabel.text = "delete"
                    //self.view.setNeedsDisplay()
                })
            }
            else
            {
                createEvent(eventStore, title: eventTitleString, startDate: startDate!, endDate: endDate!,notes: eventDescriptionString)
                DispatchQueue.main.async
                {
                    self.remindLabel.text = "delete"
                }
                //remindLabel.text = "delete"
                //self.view.setNeedsDisplay()
            }
            /* let store = EKEventStore()
             store.requestAccessToEntityType(.Event) {(granted, error) in
             if !granted { return }
             let event = EKEvent(eventStore: store)
             event.title = "Event Title"
             event.startDate = NSDate() //today
             event.endDate = event.startDate.dateByAddingTimeInterval(60*60) //1 hour long meeting
             event.calendar = store.defaultCalendarForNewEvents
             
             event. = self.eventid
             do {
             try store.saveEvent(event, span: .ThisEvent, commit: true)
             self.eventidArray.addObject(event.eventIdentifier)
             let prefs = NSUserDefaults.standardUserDefaults()
             prefs.setValue(self.eventidArray, forKey: "eventidarray")
             prefs.synchronize()
             self.remindLabel.text = "delete"
             //save event id to access this particular event later
             } catch {
             // Display error to user
             }
             }
             */
        }
        if remindLabel.text == "delete"
        {
            let eventStore = EKEventStore()
            
            if (EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized) {
                eventStore.requestAccess(to: .event, completion: { (granted, error) -> Void in
                    self.deleteEvent(eventStore, eventIdentifier: self.savedEventId)
                    self.remindLabel.text = "remind me"
                })
            } else {
                deleteEvent(eventStore, eventIdentifier: savedEventId)
                remindLabel.text = "remind me"
            }
            /* let store = EKEventStore()
             store.requestAccessToEntityType(EKEntityType.Event) {(granted, error) in
             if !granted { return }
             let eventToRemove = store.eventWithIdentifier(self.savedEventId)
             if eventToRemove != nil {
             do {
             
             try store.removeEvent(eventToRemove, span: .ThisEvent, commit: true)
             } catch {
             // Display error to user
             }
             }
             }*/
        }
        
    }
    @IBAction func shareButtonClicked(_ sender: AnyObject) {
        var firstActivityItem = "Title: "
        firstActivityItem = firstActivityItem + eventTitleString
        var secondActivityItem = "Description: "
        secondActivityItem = secondActivityItem + eventDescriptionString
        if weburlString != ""
        {
            secondActivityItem = secondActivityItem.appendingFormat("\n %@ \n", weburlString)
        }
        var thirdActivityItem = "Venue: "
        thirdActivityItem = thirdActivityItem + eventplace
        //let secondActivityItem : NSURL = NSURL(string: "http//:urlyouwant")!
        var fourthActivityItem =  "Date & Time: "
        //let date = eventdate
        let datFormatter = DateFormatter()
        datFormatter.dateFormat = "dd-MM-yyyy"
        //datFormatter.locale = NSLocale.currentLocale()
        // convert string into date
        //datFormatter.timeZone = NSTimeZone.systemTimeZone()
        let dateValue:Date  =  datFormatter.date(from: eventdate)!
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        //dateFormatter.locale = NSLocale.currentLocale()
        // convert string into date
        //dateFormatter.timeZone = NSTimeZone.init(forSecondsFromGMT: 0)
        let dateValu  =  dateFormatter.string(from: dateValue)
        fourthActivityItem = fourthActivityItem.appendingFormat("%@", dateValu)
        fourthActivityItem = fourthActivityItem + ", "
        fourthActivityItem = fourthActivityItem.appendingFormat("%@", evntTime)
        
        let fifthActivityItem = "-Shared by mConnect"
        // If you want to put an image
        //let image : UIImage = UIImage(named: "image.jpg")!
        
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem, secondActivityItem,thirdActivityItem,fourthActivityItem,fifthActivityItem], applicationActivities: nil)
        
        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = (sender as! UIButton)
        
        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection()
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)
        
        // Anything you want to exclude
        /* activityViewController.excludedActivityTypes = [
         UIActivityTypePostToWeibo,
         UIActivityTypePrint,
         UIActivityTypeAssignToContact,
         UIActivityTypeSaveToCameraRoll,
         UIActivityTypeAddToReadingList,
         UIActivityTypePostToFlickr,
         UIActivityTypePostToVimeo,
         UIActivityTypePostToTencentWeibo
         ]*/
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    func deleteEvent(_ eventStore: EKEventStore, eventIdentifier: String) {
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if (eventToRemove != nil) {
            do {
                try eventStore.remove(eventToRemove!, span: .thisEvent)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                
                appDelegate.eventreminddict.removeObject(forKey: eventid) // = newdict
                UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: appDelegate.eventreminddict), forKey: "eventremindedict")
                UserDefaults.standard.synchronize()
            } catch {
                print("Bad things happened")
            }
        }
    }
    func createEvent(_ eventStore: EKEventStore, title: String, startDate: Date, endDate: Date,notes:String) {
        let event = EKEvent(eventStore: eventStore)
        
        event.title = title
        event.notes = notes
        event.startDate = startDate
        event.endDate = endDate
        event.calendar = eventStore.defaultCalendarForNewEvents
        let myAlarmsArray = NSMutableArray()
        let alarm1 = EKAlarm(relativeOffset: -3600)// 1 Hour
        //let alarm2 = EKAlarm(relativeOffset: -300)// 5 Min
        let alarm3 = EKAlarm(relativeOffset: -86400)
        myAlarmsArray.add(alarm1)
        event.alarms = [alarm1,alarm3]
        do {
            try eventStore.save(event, span: .thisEvent)
            savedEventId = event.eventIdentifier
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let newdict = [self.eventid : self.savedEventId]
            appDelegate.eventreminddict.addEntries(from: newdict) // = newdict
            UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: appDelegate.eventreminddict), forKey: "eventremindedict")
            UserDefaults.standard.synchronize()
            print(appDelegate.eventreminddict)
        } catch {
            print("Bad things happened")
        }
    }
    @IBAction func closeButtonClicked(_ sender: AnyObject) {
        DispatchQueue.main.async
        {
            self.dismiss(animated: true, completion: nil)
        }
    }
    func setclosecolorImage(_ img:UIImage)-> UIImage
    {
        let rect:CGRect = CGRect(x: 0.0, y: 0.0, width: img.size.width, height: img.size.height);
        UIGraphicsBeginImageContextWithOptions(img.size, false, UIScreen.main.scale);
        img.draw(in: rect)
        
        let context:CGContext = UIGraphicsGetCurrentContext()!
        context.setBlendMode(CGBlendMode.sourceIn)
        //CGContextSetBlendMode(context, kCGBlendModeSourceIn);
        
        context.setFillColor(UIColor(hex:0x1986FF)!.cgColor);
        context.fill(rect);
        
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext()
        return newImage
    }
}
