//
//  languageCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/20/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class languageCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    //MARK: Variables
    var cellTitle = ""
    var cellSubtitle = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    //MARK: Functions
    func setInfo(title: String, subtitle: String) {
        cellTitle = title
        cellSubtitle = subtitle
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
}
