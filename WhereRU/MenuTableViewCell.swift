//
//  MenuTableViewCell.swift
//  WhereRU
//
//  Created by RInz on 15/7/4.
//  Copyright (c) 2015年 RInz. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var menuImage: UIImageView!
    @IBOutlet weak var menuName: UILabel!
    @IBOutlet weak var nemuNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
