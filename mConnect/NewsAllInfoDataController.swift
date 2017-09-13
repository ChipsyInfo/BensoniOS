//
//  NewsAllInfoDataController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 01/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class NewsAllInfoDataController: NSObject {
    var newsinfoArray:NSMutableArray! = NSMutableArray()
    var newsData:NewsData!
    var isValuePresent:Bool! = false
    override init()
    {
        super.init()
        self.loadAllNewsInfo()
        
    }
    func loadAllNewsInfo()
    {
        let url:URL = URL(string: "http://api.mconnect.ideationwizard.com/news")!
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
                    if let newsinfo = responseInfo["news"] as? [[String: AnyObject]]
                    {
                        
                        for DataInfo in newsinfo
                        {
                            let id = DataInfo["id"] as! Int
                            let title = DataInfo["title"] as! String
                            let descriptn = DataInfo["description"] as! String
                            let date = DataInfo["date"] as! String
                            let time = DataInfo["time"] as! String
                            let websiteurl = DataInfo["websiteurl"] as! String
                            let large_image = DataInfo["large_image"] as! String
                            let small_image = DataInfo["small_image"] as! String
                            let createddate = DataInfo["createddate"] as! String
                            let updateddate = DataInfo["updateddate"] as! String
                            
                            self.newsData = NewsData(id: id, title: title, descriptn: descriptn, date: date, time: time, websiteurl: websiteurl, large_image: large_image, small_image: small_image, createddate: createddate, updateddate: updateddate)
                            self.newsinfoArray.add(self.newsData)
                        }
                        
                    }
                }
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            NotificationCenter.default.post(name: Notification.Name(rawValue: "newsAllDataReady"), object: self, userInfo: nil)
            //NSNotificationCenter.defaultCenter().postNotificationName("newsAllDataReady", object: self, userInfo: nil)
            }.resume()
    }
}
