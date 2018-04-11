//
//  EventsData.swift
//  Town of Morrisville
//
//  Created by chipsy services on 28/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EventsData: NSObject {
    var id:Int!
    var title:String!
    var eventcategoryname:String!
    var eventcategoryid:Int!
    var descriptn:String!
    var date:String!
    var time:String!
    var time24:String!
    var day:String!
    var place:String!
    var websiteurl:String!
    var imagepath:String!
    var timestamp:Int!
    var createddate:String!
    var updateddate:String!
    var edate: String!
    var etime: String!
    var etime24: String!
    var wholeday: Bool!
    var endtime:String!
    var eventsArray:NSMutableArray!
    init( id:Int,title:String,eventcategoryname:String,eventcategoryid:Int,descriptn:String,date:String,time:String,time24:String,day:String,place:String,websiteurl:String,imagepath:String,timestamp:Int,createddate:String,updateddate:String,endtime:String!, edate: String,etime: String,etime24: String,wholeday: Bool)
    {
        self.id = id
        self.title =  title
        self.eventcategoryname = eventcategoryname
        self.eventcategoryid = eventcategoryid
        self.descriptn = descriptn
        self.date = date
        self.time = time
        self.time24 = time24
        self.day = day
        self.place = place
        self.websiteurl = websiteurl
        self.imagepath = imagepath
        self.timestamp = timestamp
        self.createddate = createddate
        self.updateddate = updateddate
        self.endtime = endtime
        self.edate = edate
        self.etime = etime
        self.etime24 = etime24
        self.wholeday = wholeday
    }
}

