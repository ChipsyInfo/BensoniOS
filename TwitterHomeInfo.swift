//
//  TwitterHomeInfo.swift
//  WESchool
//
//  Created by chipsy services on 09/12/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class TwitterHomeInfo: NSObject {

    var count: Int
    var link: String
    
    init(count: Int,link: String) {
        self.count = count
        self.link = link
    }
}
