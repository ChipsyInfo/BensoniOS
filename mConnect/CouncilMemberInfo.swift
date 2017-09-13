//
//  CouncilMemberInfo.swift
//  TownofMorrisville
//
//  Created by chipsy services on 04/08/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class CouncilMemberInfo: NSObject {
    var id: Int!
    var councillor_name: String!
    var councillor_designation: String!
    var councillor_address: String!
    var term_serving: String!
    var previosterms: String!
    var mobileNumber: String!
    var email_address: String!
    var created_date: String!
    var updated_date: String!
    var imagepath: String!
    var commitieearray: NSMutableArray!
    init( id: Int,councillor_name: String,councillor_designation: String,councillor_address: String,term_serving: String,previosterms: String,mobileNumber: String,email_address: String,created_date: String,updated_date: String,imagepath: String,commitieearray: NSMutableArray)
    {
        self.id = id
        self.councillor_name = councillor_name
        self.councillor_designation = councillor_designation
        self.councillor_address = councillor_address
        self.term_serving = term_serving
        self.previosterms = previosterms
        self.mobileNumber = mobileNumber
        self.email_address = email_address
        self.created_date = created_date
        self.updated_date = updated_date
        self.imagepath = imagepath
        self.commitieearray = commitieearray
        
    }
}
