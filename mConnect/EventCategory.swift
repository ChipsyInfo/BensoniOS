//
//  EventCategory.swift
//  TownofMorrisville
//
//  Created by chipsy services on 09/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EventCategory: NSObject {
    var eventcategoryid:Int!
    var eventcategoryname:String!
    init( eventcategoryid:Int,eventcategoryname:String)
    {
        self.eventcategoryname = eventcategoryname
        self.eventcategoryid = eventcategoryid
    }
}
