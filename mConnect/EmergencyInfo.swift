//
//  EmergencyInfo.swift
//  TownofMorrisville
//
//  Created by chipsy services on 03/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class EmergencyInfo: NSObject {
    var id:Int!
    var emergeny_name:String!
    var stdcode:String!
    var emergeny_number:String!
    var created_date:String!
    var updated_date:String!
    init( id:Int,emergeny_name:String,stdcode:String,emergeny_number:String,created_date:String,updated_date:String)
    {
        self.id = id
        self.emergeny_name = emergeny_name
        self.stdcode = stdcode
        self.emergeny_number = emergeny_number
        self.created_date = created_date
        self.updated_date = updated_date
    }
}
