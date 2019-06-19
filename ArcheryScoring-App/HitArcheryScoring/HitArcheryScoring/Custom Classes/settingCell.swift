//
//  settingCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/18/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class settingCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var longSettingLabel: UILabel!
    @IBOutlet weak var shortSettingLabel: UILabel!
    @IBOutlet weak var currChoiceLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Functions
    func setInfo(title: String, choiceTitle: String?) {
        if choiceTitle == nil {
            longSettingLabel.text = title
            shortSettingLabel.isHidden = true
            currChoiceLabel.isHidden = true
        } else {
            shortSettingLabel.text = title
            currChoiceLabel.text = choiceTitle
            longSettingLabel.isHidden = true
        }
    }
}
