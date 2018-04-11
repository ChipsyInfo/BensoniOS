//
//  TwitterInfo.swift
//  TownofMorrisville
//
//  Created by chipsy services on 02/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class TwitterInfo: NSObject {
    var id:Int!
    var title:String!
    var link:String!
    var desc:String!
    var imagepath:String!
    var createddate:String!
    var updateddate:String!
    init( id:Int,title:String,link:String,desc:String,imagepath:String,createddate:String,updateddate:String)
    {
        self.id = id
        self.title = title
        self.link = link
        self.desc = desc
        self.imagepath = imagepath
        self.createddate = createddate
        self.updateddate = updateddate
    }
}