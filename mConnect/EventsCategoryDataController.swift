//
//  EventsCategoryDataController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 09/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EventsCategoryDataController: NSObject {
    var eventcategoryinfoArray:NSMutableArray! = NSMutableArray()
    
    var eventCategoryData:EventCategory!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadAllEventCategoryInfo()
        
    }
    func loadAllEventCategoryInfo()
    {
        let url:URL = URL(string: "https://apimconnect.ideationwizard.com/event_category")!
        // let session = URLSession.shared
        
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
                    if let councilinfo = responseInfo["events"] as? [[String: AnyObject]]
                    {
                        for DataInfo in councilinfo
                        {
                            let eventcategoryid = DataInfo["eventcategoryid"] as! Int
                            let eventcategoryname = DataInfo["eventcategoryname"] as! String
                            
                            
                            self.eventCategoryData = EventCategory(eventcategoryid: eventcategoryid, eventcategoryname: eventcategoryname)
                            // self.councilData = CouncilMemberInfo(id: id, councillor_name: councillor_name, councillor_designation: councillor_designation, councillor_address: councillor_address, term_serving: term_serving, previosterms: previosterms, mobileNumber: mobileNumber, email_address: email_address, created_date: created_date, updated_date: updated_date, imagepath: imagepath, commitieearray: self.commiteearray)
                            self.eventcategoryinfoArray.add(self.eventCategoryData)
                            
                        }
                        
                    }
                }
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "eventCategoryAllDataReady"), object: self, userInfo: nil)
            //NSNotificationCenter.defaultCenter().postNotificationName("newsAllDataReady", object: self, userInfo: nil)
            }.resume()
    }
}
