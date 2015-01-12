//
//  EventTableViewCell.swift
//  WhereRU
//
//  Created by RInz on 14/10/28.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

public class EventTableViewCell: SWTableViewCell {
    
    @IBOutlet weak var eventMessage: UILabel!
    @IBOutlet weak var eventDateTime: UILabel!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
