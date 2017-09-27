//
//  EmergencyInfoDataController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 03/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EmergencyInfoDataController: NSObject {
    var emergencyinfoArray:NSMutableArray! = NSMutableArray()
    var emergencyCategoryinfoArray:NSMutableArray! = NSMutableArray()
    var emergencyData:EmergencyInfo!
    var emergencyCategoryData:EmergencyCategoryInfo!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadAllEmergencyInfo()
        
    }
    func loadAllEmergencyInfo()
    {
        let url:URL = URL(string: "https://apimconnect.ideationwizard.com/emergeny")!
        //let session = URLSession.shared
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
        //request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
        //self.emergencyCategoryData.emergencyArray = NSMutableArray()
        //self.emergencyCategoryData.emergencyCategoryarray = NSMutableArray()
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
                    if let emergencyinfo = responseInfo["emergeny"] as? [[String: AnyObject]]
                    {
                        for DataInfo in emergencyinfo
                        {
                            
                            let categoryId = DataInfo["categoryId"] as! Int
                            let categoryName = DataInfo["categoryName"] as! String
                            self.emergencyinfoArray = NSMutableArray()
                            if let mobileinfo = DataInfo["mobile"] as? [[String: AnyObject]]
                            {
                                for mobileDataInfo in mobileinfo
                                {
                                    let id = mobileDataInfo["id"] as! Int
                                    let emergeny_name = mobileDataInfo["emergeny_name"] as! String
                                    let stdcode = mobileDataInfo["stdcode"] as! String
                                    let emergeny_number = mobileDataInfo["emergeny_number"] as! String
                                    let created_date = mobileDataInfo["created_date"] as! String
                                    let updated_date = mobileDataInfo["updated_date"] as! String
                                    self.emergencyData = EmergencyInfo(id: id, emergeny_name: emergeny_name, stdcode: stdcode, emergeny_number: emergeny_number, created_date: created_date, updated_date: updated_date)
                                    self.emergencyinfoArray.add(self.emergencyData)
                                }
                                //self.emergencyCategoryData.emergencyArray = NSMutableArray()
                                
                            }
                            self.emergencyCategoryData = EmergencyCategoryInfo(categoryId: categoryId, categoryName: categoryName, emergencyArray: self.emergencyinfoArray)
                            if self.emergencyinfoArray.count > 0
                            {
                                self.emergencyCategoryinfoArray.add(self.emergencyCategoryData)
                            }
                            
                            // self.emergencyinfoArray.addObject(self.emergencyData)
                            
                        }
                        self.emergencyCategoryData.emergencyCategoryarray = self.emergencyCategoryinfoArray
                        
                    }
                }
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "emergencyAllDataReady"), object: self, userInfo: nil)
            //NSNotificationCenter.defaultCenter().postNotificationName("newsAllDataReady", object: self, userInfo: nil)
            }.resume()
    }
}
