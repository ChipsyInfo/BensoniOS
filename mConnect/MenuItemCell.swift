//
//  MenuItemCell.swift
//  Town of Morrisville
//
//  Created by chipsy services on 27/07/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
    @IBOutlet weak var menuItemIconImageview: UIImageView!
    @IBOutlet weak var menuItemLabel: UILabel!
    @IBOutlet weak var imageBottomSpace: NSLayoutConstraint!
    
    @IBOutlet weak var imageTopSpace: NSLayoutConstraint!
    @IBOutlet weak var menuItemTitleBottomSpace: NSLayoutConstraint!
    @IBOutlet weak var menuItemTitleTopSpace: NSLayoutConstraint!
    @IBOutlet weak var menuImageLeadingSpace: NSLayoutConstraint!
    @IBOutlet weak var menuTitleLeading: NSLayoutConstraint!
}
