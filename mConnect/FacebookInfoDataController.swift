//
//  FacebookInfoDataController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 29/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class FacebookInfoDataController: NSObject {
    var facebookArray:NSMutableArray! = NSMutableArray()
    var facebookData:FacebookInfo!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadFacebookInfo()
        
    }
    func loadFacebookInfo()
    {
        let url:URL = URL(string: "https://apimconnect.ideationwizard.com/socialmedia/facebook")!
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
                    if let facebookinfo = responseInfo["socail_media"] as? [[String: AnyObject]]
                    {
                        
                        for DataInfo in facebookinfo
                        {
                            let id = DataInfo["id"] as! Int
                            let title = DataInfo["title"] as! String
                            let link = DataInfo["link"] as! String
                            let descriptn = DataInfo["description"] as! String
                            let imagepath = DataInfo["imagepath"] as! String
                            let createddate = DataInfo["createddate"] as! String
                            let updateddate = DataInfo["updateddate"] as! String
                            
                            self.facebookData = FacebookInfo(id: id, title: title, link: link, desc: descriptn, imagepath: imagepath, createddate: createddate, updateddate: updateddate)
                            self.facebookArray.add(self.facebookData)
                        }
                        
                    }
                    
                }
                self.isValuePresent = true
                NotificationCenter.default.post(name: Notification.Name(rawValue: "FacebookdataReady"), object: self, userInfo: nil)
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            
            
            
            }.resume()
    }
}
