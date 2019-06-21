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
    
    //MARK: Variables
    var cellTitle = ""
    var subTitle = true
    let kVersion = "CFBundleShortVersionString"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    //MARK: Functions
    func setInfo(title: String) {
        cellTitle = title
        if title == "Version" {
            shortSettingLabel.text = title
            currChoiceLabel.text = getVersion()
            longSettingLabel.isHidden = true
            self.accessoryType = .none
        } else if title == "Language" {
            shortSettingLabel.text = title
            currChoiceLabel.text = UserDefaults.standard.value(forKey: "Language") as? String
            longSettingLabel.isHidden = true
        } else if title == "Distance Unit" {
            shortSettingLabel.text = title
            currChoiceLabel.text = UserDefaults.standard.value(forKey: "DistanceUnit") as? String
            longSettingLabel.isHidden = true
        } else {
            longSettingLabel.text = title
            shortSettingLabel.isHidden = true
            currChoiceLabel.isHidden = true
            subTitle = false
        }
    }
    
    func getVersion() -> String {
        let dict = Bundle.main.infoDictionary!
        let version = dict[kVersion] as! String
        return version
    }
}
