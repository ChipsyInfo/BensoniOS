//
//  HomeInfoDataController.swift
//  Town of Morrisville
//
//  Created by chipsy services on 28/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class HomeInfoDataController: NSObject {
    var isValuePresent:Bool! = false
    var eventsArray:NSMutableArray! = NSMutableArray()
    var newsArray:NSMutableArray! = NSMutableArray()
    var bannerArray:NSMutableArray! = NSMutableArray()
    var facebookCount:Int! = 0
    var twitterCount:Int! = 0
    var youtubeCount:Int! = 0
    
    var facebookListarray:NSMutableArray! = NSMutableArray()
    var twitterListarray:NSMutableArray! = NSMutableArray()
    var youtubeListarray:NSMutableArray! = NSMutableArray()
    
    var fblink:String!
    var twitterlink:String!
    var youtubelink:String!
    
    var facebookList:FacebookHomeInfo!
    var twitterList:TwitterHomeInfo!
    var youtubeList:YoutubeCountInfo!
    
    var news:NewsData!
    var events:EventsData!
    var banners:ImageBanner!
    var homescreeninfo:HomeInfo!
    override init()
    {
        super.init()
        self.loadHomeScreenData()
        
    }
    func loadHomeScreenData()
    {
        
        let url:URL = URL(string: "https://apimconnect.ideationwizard.com/home")!
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
                    if let homefacebookinfo = responseInfo["facebook"] as? NSDictionary
                    {
                        self.facebookCount =  homefacebookinfo["count"] as! Int
                        self.fblink  = homefacebookinfo["link"] as! String
                        
                        self.facebookList = FacebookHomeInfo(count: self.facebookCount, link: self.fblink)
                        self.facebookListarray.add(self.facebookList)
                    }
                    if let hometwitterinfo = responseInfo["twitter"] as? NSDictionary
                    {
                        self.twitterCount =  hometwitterinfo["count"] as! Int
                        self.twitterlink = hometwitterinfo["link"] as! String
                        
                        self.twitterList = TwitterHomeInfo(count: self.twitterCount, link: self.twitterlink)
                        self.twitterListarray.add(self.twitterList)
                    }
                    if let homeyoutubeinfo = responseInfo["youtube"] as? NSDictionary
                    {
                        self.youtubeCount =  homeyoutubeinfo["count"] as! Int
                        self.youtubelink = homeyoutubeinfo["link"] as! String
                        
                        self.youtubeList = YoutubeCountInfo(count: self.youtubeCount, link: self.youtubelink)
                        self.youtubeListarray.add(self.youtubeList)
                    }
                    if let homenewsinfo = responseInfo["news"] as? [[String: AnyObject]]
                    {
                        for DataInfo in homenewsinfo
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
                            
                            self.news = NewsData(id: id, title: title, descriptn: descriptn, date: date, time: time, websiteurl: websiteurl, large_image: large_image, small_image: small_image, createddate: createddate, updateddate: updateddate)
                            self.newsArray.add(self.news)
                        }
                        
                    }
                    if let homeeventsinfo = responseInfo["events"] as? [[String: AnyObject]]
                    {
                        for DataInfo in homeeventsinfo
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
                            self.events = EventsData(id: id, title: title, eventcategoryname: eventcategoryname, eventcategoryid: eventcategoryid, descriptn: descriptn, date: date, time: time, time24: time24, day: day, place: place, websiteurl: websiteurl, imagepath: imagepath, timestamp: timestamp, createddate: createddate, updateddate: updateddate,endtime: endtime, edate: edate,etime: etime,etime24: etime24, wholeday: wholeday )
                            self.eventsArray.add(self.events)
                            
                        }
                        
                    }
                    if let homebannerinfo = responseInfo["banner"] as? [[String: AnyObject]]
                    {
                        for DataInfo in homebannerinfo
                        {
                            let imagepath = DataInfo["imagepath"] as! String
                            let timestamp = DataInfo["timestamp"] as! Int
                            self.banners = ImageBanner(imagepath: imagepath, timestamp: timestamp)
                            self.bannerArray.add(self.banners)
                        }
                        
                    }
                    
                }
                if self.facebookCount == 1
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadFacebookCount"), object: self, userInfo: ["number":self.facebookCount,"link":self.fblink])
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadFacebookCount"), object: self, userInfo: ["number":self.facebookCount,"link":self.fblink])
                }
                if self.twitterCount == 1
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTwitterCount"), object: self, userInfo: ["number":self.twitterCount,"link":self.twitterlink])
                    
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTwitterCount"), object: self, userInfo: ["number":self.twitterCount,"link":self.twitterlink])
                    
                }
                if self.youtubeCount == 1
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadYoutubeCount"), object: self, userInfo: ["number":self.youtubeCount,"link":self.youtubelink])
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadYoutubeCount"), object: self, userInfo: ["number":self.youtubeCount,"link":self.youtubelink])
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.facebookCount = self.facebookCount
                appDelegate.twitterCount = self.twitterCount
                
                appDelegate.fblink = self.fblink
                appDelegate.twitterlink = self.twitterlink
                
                self.homescreeninfo = HomeInfo(bannerArray: self.bannerArray, eventArray: self.eventsArray, newsArray: self.newsArray,facebookListArray: self.facebookListarray, twitterListArray: self.twitterListarray)
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "dataIsReady"), object: self, userInfo: nil)
            
            }.resume()
    }
    
    func updateScreenData()
    {
        self.eventsArray.removeAllObjects()
        self.newsArray.removeAllObjects()
        self.bannerArray.removeAllObjects()
        let url:URL = URL(string: "https://apimconnect.ideationwizard.com/home")!
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
                    if let homefacebookinfo = responseInfo["facebook"] as? NSDictionary
                    {
                        
                        
                        self.facebookCount =  homefacebookinfo["count"] as! Int
                        self.fblink  = homefacebookinfo["link"] as! String
                        
                        self.facebookList = FacebookHomeInfo(count: self.facebookCount, link: self.fblink)
                        self.facebookListarray.add(self.facebookList)
                        
                        
                    }
                    if let hometwitterinfo = responseInfo["twitter"] as? NSDictionary
                    {
                        
                        
                        self.twitterCount =  hometwitterinfo["count"] as! Int
                        self.twitterlink = hometwitterinfo["link"] as! String
                        
                        self.twitterList = TwitterHomeInfo(count: self.twitterCount, link: self.twitterlink)
                        self.twitterListarray.add(self.twitterList)
                        
                        
                    }
                    if let homenewsinfo = responseInfo["news"] as? [[String: AnyObject]]
                    {
                        
                        for DataInfo in homenewsinfo
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
                            
                            self.news = NewsData(id: id, title: title, descriptn: descriptn, date: date, time: time, websiteurl: websiteurl, large_image: large_image, small_image: small_image, createddate: createddate, updateddate: updateddate)
                            self.newsArray.add(self.news)
                        }
                        
                    }
                    if let homeeventsinfo = responseInfo["events"] as? [[String: AnyObject]]
                    {
                        for DataInfo in homeeventsinfo
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
                            self.events = EventsData(id: id, title: title, eventcategoryname: eventcategoryname, eventcategoryid: eventcategoryid, descriptn: descriptn, date: date, time: time, time24: time24, day: day, place: place, websiteurl: websiteurl, imagepath: imagepath, timestamp: timestamp, createddate: createddate, updateddate: updateddate,endtime: endtime, edate: edate,etime: etime,etime24: etime24, wholeday: wholeday )
                            self.eventsArray.add(self.events)
                            
                        }
                        
                    }
                    if let homebannerinfo = responseInfo["banner"] as? [[String: AnyObject]]
                    {
                        for DataInfo in homebannerinfo
                        {
                            let imagepath = DataInfo["imagepath"] as! String
                            let timestamp = DataInfo["timestamp"] as! Int
                            self.banners = ImageBanner(imagepath: imagepath, timestamp: timestamp)
                            self.bannerArray.add(self.banners)
                        }
                        
                    }
                    
                }
                if self.facebookCount == 1
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadFacebookCount"), object: self, userInfo: ["number":self.facebookCount,"link":self.fblink])
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadFacebookCount"), object: self, userInfo: ["number":self.facebookCount,"link":self.fblink])
                }
                if self.twitterCount == 1
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTwitterCount"), object: self, userInfo: ["number":self.twitterCount,"link":self.twitterlink])
                    
                }
                else
                {
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadTwitterCount"), object: self, userInfo: ["number":self.twitterCount,"link":self.twitterlink])
                }
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.facebookCount = self.facebookCount
                appDelegate.twitterCount = self.twitterCount
                
                appDelegate.fblink = self.fblink
                appDelegate.twitterlink = self.twitterlink
                
                self.homescreeninfo = HomeInfo(bannerArray: self.bannerArray, eventArray: self.eventsArray, newsArray: self.newsArray,facebookListArray: self.facebookListarray, twitterListArray: self.twitterListarray)
                self.isValuePresent = true
                
            }catch {
                print("Error with Json: \(error)")
                self.isValuePresent = false
            }
            let info = NSDictionary(object: self.homescreeninfo.newsArray, forKey: "newsArray" as NSCopying)
            NotificationCenter.default.post(name: Notification.Name(rawValue: "NewsUpdate"), object: nil, userInfo: info as? [AnyHashable: Any])
            
            
            }.resume()
    }
}
