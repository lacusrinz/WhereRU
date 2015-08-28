//
//  EventCell.swift
//  WhereRU
//
//  Created by RInz on 15/7/4.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class EventCell: UITableViewCell {

    @IBOutlet weak var completeFlag: UIImageView!
    @IBOutlet weak var eventTitle: UILabel!
    @IBOutlet weak var eventTime: UILabel!
    @IBOutlet weak var eventLocation: UILabel!
    @IBOutlet weak var firstParticipatorAvatarImageView: avatarImageView!
    @IBOutlet weak var secondParticipatorAvatarImageView: avatarImageView!
    @IBOutlet weak var moreParticipatorAvatarImageView: avatarImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
