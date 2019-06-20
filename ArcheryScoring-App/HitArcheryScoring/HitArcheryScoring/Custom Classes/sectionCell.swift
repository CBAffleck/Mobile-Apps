//
//  sectionCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/19/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class sectionCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setInfo(title: String) {
        titleLabel.text = title
    }
}
