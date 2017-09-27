//
//  YoutubeInfoDataController.swift
//  WESchool
//
//  Created by chipsy services on 10/12/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class YoutubeInfoDataController: NSObject {

        var youtubeArray:NSMutableArray! = NSMutableArray()
        var youtubeData:YoutubeInfo!
        var isValuePresent:Bool! = false
        var AppDelegateData:AppDelegate!
        override init()
        {
            super.init()
            self.loadYoutubeInfo()
            
        }
        func loadYoutubeInfo()
        {
            AppDelegateData = UIApplication.shared.delegate as! AppDelegate!
            let url:URL = URL(string: "https://apimconnect.ideationwizard.com/youtube")!
            // let session = URLSession.shared
            
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.cachePolicy = NSURLRequest.CachePolicy.reloadIgnoringCacheData
            //request.HTTPBody = paramString.dataUsingEncoding(NSUTF8StringEncoding)
            
            URLSession.shared.dataTask(with: request as URLRequest) {
                (data, response, error) in
                
                guard let _:Data = data, let _:URLResponse = response  , error == nil else {
                    print("error")
                    self.AppDelegateData.YouTubeArrayCountHome = 0
                    return
                }
                do{
                    
                    let json = try JSONSerialization.jsonObject(with: data!, options: [])
                    guard let data_dictionary = json as? NSDictionary else
                    {
                        self.AppDelegateData.YouTubeArrayCountHome = 0
                        return
                    }
                    
                    
                    if let responseInfo = data_dictionary["data"] as? NSDictionary
                    {
                        if let facebookinfo = responseInfo["youtube"] as? [[String: AnyObject]]
                        {
                            
                            for DataInfo in facebookinfo
                            {
                                let id = DataInfo["id"] as? Int ?? 0
                                let title = DataInfo["title"] as? String ?? ""
                                let link = DataInfo["link"] as? String ?? ""
                                let descriptn = DataInfo["description"] as? String ?? ""
                                let imagepath = DataInfo["imagepath"] as? String ?? ""
                                let createddate = DataInfo["createddate"] as? String ?? ""
                                let updateddate = DataInfo["updateddate"] as? String ?? ""
                                
                                self.youtubeData = YoutubeInfo(id: id, title: title, link: link, desc: descriptn, imagepath: imagepath, createddate: createddate, updateddate: updateddate)
                                self.youtubeArray.add(self.youtubeData)
                                
                                
                                
                            }
                            
                        }
                        
                    }
                    self.isValuePresent = true
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "YoutubedataReady"), object: self, userInfo: nil)
                }catch {
                    print("Error with Json: \(error)")
                    self.AppDelegateData.YouTubeArrayCountHome = 0
                    self.isValuePresent = false
                }
                
                
                
                }.resume()
        }
}
