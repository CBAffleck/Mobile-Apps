//
//  passwordPopUp.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/8/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class passwordPopUp: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var upperLabel: UILabel!
    @IBOutlet weak var lowerLabel: UILabel!
    @IBOutlet weak var numLabel: UILabel!
    @IBOutlet weak var specialLabel: UILabel!
    @IBOutlet weak var minLabel: UILabel!
    
    //MARK: Variables
    var upperCase = false
    var lowerCase = false
    var number = false
    var specialChar = false
    var length = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if upperCase {
            upperLabel.textColor = UIColor.init(red: 130/255, green: 221/255, blue: 130/255, alpha: 1.0)
        } else {
            upperLabel.textColor = UIColor.init(red: 255/255, green: 139/255, blue: 139/255, alpha: 1.0)
        }
        if lowerCase {
            lowerLabel.textColor = UIColor.init(red: 130/255, green: 221/255, blue: 130/255, alpha: 1.0)
        } else {
            lowerLabel.textColor = UIColor.init(red: 255/255, green: 139/255, blue: 139/255, alpha: 1.0)
        }
        if number {
            numLabel.textColor = UIColor.init(red: 130/255, green: 221/255, blue: 130/255, alpha: 1.0)
        } else {
            numLabel.textColor = UIColor.init(red: 255/255, green: 139/255, blue: 139/255, alpha: 1.0)
        }
        if specialChar {
            specialLabel.textColor = UIColor.init(red: 130/255, green: 221/255, blue: 130/255, alpha: 1.0)
        } else {
            specialLabel.textColor = UIColor.init(red: 255/255, green: 139/255, blue: 139/255, alpha: 1.0)
        }
        if length {
            minLabel.textColor = UIColor.init(red: 130/255, green: 221/255, blue: 130/255, alpha: 1.0)
        } else {
            minLabel.textColor = UIColor.init(red: 255/255, green: 139/255, blue: 139/255, alpha: 1.0)
        }
        upperLabel.text = "-one upper case letter\n"
        lowerLabel.text = "-one lower case letter\n"
        numLabel.text = "-one number\n"
        specialLabel.text = "-one special character\n"
        minLabel.text = "-a minimum length of 8"
    }

    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
