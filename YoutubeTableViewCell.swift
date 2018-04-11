//
//  YoutubeTableViewCell.swift
//  WESchool
//
//  Created by chipsy services on 12/12/16.
//  Copyright © 2016 chipsy services. All rights reserved.
//

import UIKit

class YoutubeTableViewCell: UITableViewCell {
    @IBOutlet weak var cellInsideView: UIView!
    @IBOutlet weak var cellbackgroundImage: UIImageView!
    
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var cellCircleImage: UIImageView!
    @IBOutlet weak var cellBlueFbTitle: UILabel!
    @IBOutlet weak var cellWhiteFbTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
