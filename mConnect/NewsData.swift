//
//  NewsData.swift
//  Town of Morrisville
//
//  Created by chipsy services on 28/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class NewsData: NSObject {
    var id:Int!
    var title:String!
    var descriptn:String!
    var date:String!
    var time:String!
    var websiteurl:String!
    var large_image:String!
    var small_image:String!
    var createddate:String!
    var updateddate:String!
    init( id:Int,title:String,descriptn:String,date:String,time:String,websiteurl:String,large_image:String,small_image:String,createddate:String,updateddate:String)
    {
        self.id = id
         self.title = title
         self.descriptn = descriptn
         self.date = date
         self.time = time
         self.websiteurl = websiteurl
         self.large_image = large_image
         self.small_image = small_image
         self.createddate = createddate
         self.updateddate = updateddate
    }
}
