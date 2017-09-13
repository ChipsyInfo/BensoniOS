//
//  CouncilMemberInfoDataController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 04/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class CouncilMemberInfoDataController: NSObject {
    var councilinfoArray:NSMutableArray! = NSMutableArray()
    var commiteearray:NSMutableArray! = NSMutableArray()
    var councilData:CouncilMemberInfo!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadAllCouncilMemberInfo()
        
    }
    func loadAllCouncilMemberInfo()
    {
        //api.mconnect.ideationwizard.com
        let url:URL = URL(string: "http://api.mconnect.ideationwizard.com/councillor")!
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
                    if let councilinfo = responseInfo["council"] as? [[String: AnyObject]]
                    {
                        for DataInfo in councilinfo
                        {
                            let id = DataInfo["id"] as! Int
                            let councillor_name = DataInfo["councillor_name"] as! String
                            let councillor_designation = DataInfo["councillor_designation"] as! String
                            let councillor_address = DataInfo["councillor_address"] as! String
                            let term_serving = DataInfo["term_serving"] as! String
                            let previosterms = DataInfo["previosterms"] as! String
                            let mobileNumber = DataInfo["mobileNumber"] as! String
                            let email_address = DataInfo["email_address"] as! String
                            let created_date = DataInfo["created_date"] as! String
                            let updated_date = DataInfo["updated_date"] as! String
                            let imagepath = DataInfo["imagepath"] as! String
                            if let committeeinfo = DataInfo["commitiee"] as? [[String: AnyObject]]
                            {
                                self.commiteearray = NSMutableArray()
                                for comtinfo in committeeinfo
                                {
                                    let commitiee_description = comtinfo["commitiee_description"] as! String
                                    self.commiteearray.add(commitiee_description)
                                }
                            }
                            
                            self.councilData = CouncilMemberInfo(id: id, councillor_name: councillor_name, councillor_designation: councillor_designation, councillor_address: councillor_address, term_serving: term_serving, previosterms: previosterms, mobileNumber: mobileNumber, email_address: email_address, created_date: created_date, updated_date: updated_date, imagepath: imagepath, commitieearray: self.commiteearray)
                            self.councilinfoArray.add(self.councilData)
                            
                        }
                        
                    }
                }
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "councilmemberAllDataReady"), object: self, userInfo: nil)
            //NSNotificationCenter.defaultCenter().postNotificationName("newsAllDataReady", object: self, userInfo: nil)
            }.resume()
    }
}
