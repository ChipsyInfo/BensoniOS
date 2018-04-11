//
//  HomeInfo.swift
//  Town of Morrisville
//
//  Created by chipsy services on 28/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class HomeInfo: NSObject {
    var bannerArray:NSArray!
    var eventArray:NSArray!
    var newsArray:NSArray!
    var facebookListArray:NSArray!
    var twitterListArray:NSArray!
    init( bannerArray:NSArray,eventArray:NSArray,newsArray:NSArray,facebookListArray:NSArray,twitterListArray:NSArray)
    {
        self.bannerArray = bannerArray
        self.eventArray = eventArray
        self.newsArray = newsArray
        self.facebookListArray = facebookListArray
        self.twitterListArray = twitterListArray
    }
}
