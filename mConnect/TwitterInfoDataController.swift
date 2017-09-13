//
//  TwitterInfoDataController.swift
//  TownofMorrisville
//
//  Created by chipsy services on 02/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class TwitterInfoDataController: NSObject {
    var twitterArray:NSMutableArray! = NSMutableArray()
    var twitterData:TwitterInfo!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadTwitterInfo()
        
    }
    func loadTwitterInfo()
    {
        let url:URL = URL(string: "http://api.mconnect.ideationwizard.com/socialmedia/twitter")!
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
                    if let twitterinfo = responseInfo["socail_media"] as? [[String: AnyObject]]
                    {
                        
                        for DataInfo in twitterinfo
                        {
                            let id = DataInfo["id"] as! Int
                            let title = DataInfo["title"] as! String
                            let link = DataInfo["link"] as! String
                            let descriptn = DataInfo["description"] as! String
                            let imagepath = DataInfo["imagepath"] as! String
                            let createddate = DataInfo["createddate"] as! String
                            let updateddate = DataInfo["updateddate"] as! String
                            
                            self.twitterData = TwitterInfo(id: id, title: title, link: link, desc: descriptn, imagepath: imagepath, createddate: createddate, updateddate: updateddate)
                            self.twitterArray.add(self.twitterData)
                        }
                        
                    }
                    
                }
                self.isValuePresent = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "twitterdataReady"), object: self, userInfo: nil)
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            
            
            
            }.resume()
    }
}
