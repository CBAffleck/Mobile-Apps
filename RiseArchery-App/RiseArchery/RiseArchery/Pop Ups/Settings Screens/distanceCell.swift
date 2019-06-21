//
//  distanceCell.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/19/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class distanceCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    
    //MARK: Variables
    var cellTitle = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Functions
    func setInfo(title: String) {
        cellTitle = title
        titleLabel.text = title
    }
}
