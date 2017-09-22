//
//  YoutubeCountInfo.swift
//  mConnect
//
//  Created by Chipsy on 22/09/17.
//  Copyright © 2017 chipsy services. All rights reserved.
//

import UIKit

class YoutubeCountInfo: NSObject {
    var count: Int
    var link: String
    init(count: Int,link: String) {
        self.count = count
        self.link = link
    }
}
