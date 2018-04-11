//
//  EmergencyCategoryInfo.swift
//  mConnect
//
//  Created by chipsy services on 31/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EmergencyCategoryInfo: NSObject {
    var categoryId:Int!
    var categoryName:String!
    var emergencyArray:NSMutableArray!
    var emergencyCategoryarray:NSMutableArray!
    init( categoryId:Int,categoryName:String,emergencyArray:NSMutableArray) {
        self.categoryId = categoryId
        self.categoryName = categoryName
        self.emergencyArray = emergencyArray
        //self.emergencyCategoryarray = emergencyCategoryarray
    }
}
