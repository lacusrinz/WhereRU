//
//  EventTableViewCell.swift
//  WhereRU
//
//  Created by RInz on 14/10/28.
//  Copyright (c) 2014年 RInz. All rights reserved.
//

import UIKit

class EventTableViewCell: JASwipeCell {
    var titleLabel:UILabel = UILabel.newAutoLayoutView()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        titleLabel.numberOfLines = 0
        self.topContentView.addSubview(titleLabel)
    }
    
    override func updateConstraints() {
        super.updateConstraints()
        titleLabel.autoPinEdgeToSuperviewEdge(ALEdge.Left, withInset: 10)
        titleLabel.autoAlignAxisToSuperviewAxis(ALAxis.Vertical)
        titleLabel.autoAlignAxisToSuperviewAxis(ALAxis.Horizontal)
    }
    
    func configureCellWithTitle(title: NSString){
        self.titleLabel.text = title
    }

}
