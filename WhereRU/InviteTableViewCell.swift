//
//  InviteTableViewCell.swift
//  WhereRU
//
//  Created by RInz on 15/2/27.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class InviteTableViewCell: UITableViewCell {

    @IBOutlet weak var eventMessage: UILabel!
    @IBOutlet weak var eventDatetime: UILabel!
    @IBOutlet weak var numberOfAccept: UILabel!
    @IBOutlet weak var numberOfRefuse: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
