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
    @IBOutlet weak var eventStatus: UIImageView!
    @IBOutlet weak var numberOfAccept: UILabel!
    
    var cellParticipant:Int = 0
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
