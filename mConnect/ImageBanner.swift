//
//  ImageBanner.swift
//  Town of Morrisville
//
//  Created by chipsy services on 28/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class ImageBanner: NSObject {
    var imagepath:String!
    var timestamp:Int!
    init(imagepath:String,timestamp:Int)
    {
        self.imagepath = imagepath
        self.timestamp = timestamp
    }
    
}
