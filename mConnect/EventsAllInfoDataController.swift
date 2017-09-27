//
//  EventsAllInfoDataController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 01/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EventsAllInfoDataController: NSObject {
    var eventsinfoArray:NSMutableArray! = NSMutableArray()
    var eventsData:EventsData!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadAllEventsInfo()
        
    }
    func loadAllEventsInfo()
    {
        let url:URL = URL(string: "https://apimconnect.ideationwizard.com/events")!
        //let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        //request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        
        URLSession.shared.dataTask(with: request as URLRequest) {
            (data, response, error) in
            
            guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                print("error")
                return
            }
            do{
                
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                guard let data_dictionary = json as? NSDictionary else
                {
                    return
                }
                
                
                if let responseInfo = data_dictionary["data"] as? NSDictionary
                {
                    if let eventsinfo = responseInfo["events"] as? [[String: AnyObject]]
                    {
                        for DataInfo in eventsinfo
                        {
                            let id = DataInfo["id"] as! Int
                            let title = DataInfo["title"] as! String
                            let eventcategoryname = DataInfo["eventcategoryname"] as! String
                            let eventcategoryid = DataInfo["eventcategoryid"] as! Int
                            let descriptn = DataInfo["description"] as! String
                            let date = DataInfo["date"] as! String
                            let time = DataInfo["time"] as! String
                            let time24 = DataInfo["time24"] as! String
                            let day = DataInfo["day"] as! String
                            let place = DataInfo["place"] as! String
                            let websiteurl = DataInfo["websiteurl"] as! String
                            let imagepath = DataInfo["imagepath"] as! String
                            let timestamp = DataInfo["timestamp"] as! Int
                            let createddate = DataInfo["createddate"] as! String
                            let updateddate = DataInfo["updateddate"] as! String
                            let endtime = DataInfo["endtime"] as! String
                            let edate = DataInfo["edate"] as! String
                            let etime = DataInfo["etime"] as! String
                            let etime24 = DataInfo["etime24"] as! String
                            let wholeday = DataInfo["wholeday"] as! Bool
                            self.eventsData = EventsData(id: id, title: title, eventcategoryname: eventcategoryname, eventcategoryid: eventcategoryid, descriptn: descriptn, date: date, time: time, time24: time24, day: day, place: place, websiteurl: websiteurl, imagepath: imagepath, timestamp: timestamp, createddate: createddate, updateddate: updateddate,endtime: endtime, edate: edate,etime: etime,etime24: etime24, wholeday: wholeday )
                            self.eventsinfoArray.add(self.eventsData)
                            
                        }
                        
                    }
                }
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "eventsAllDataReady"), object: self, userInfo: nil)
            //NSNotificationCenter.defaultCenter().postNotificationName("newsAllDataReady", object: self, userInfo: nil)
            }.resume()
    }
}
