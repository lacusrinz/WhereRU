//
//  AddParticipantTableViewCell.swift
//  WhereRU
//
//  Created by RInz on 15/1/1.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit
import avatarImageView

class AddParticipantTableViewCell: UITableViewCell {

    @IBOutlet weak var avatar: avatarImageView!
    @IBOutlet weak var name: UILabel!
    
    var selectedFriend:Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
