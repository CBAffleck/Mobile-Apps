//
//  emailPopUp.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class emailPopUp: UIViewController {

    //MARK: Properties
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let infoString = NSMutableAttributedString(string: "Currently only UC Berkeley students and faculty with a valid Cal email are being accepted. Please use your ")
        let emailString = NSMutableAttributedString(string: "@berkeley.edu")
        emailString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.init(red: 75/255, green: 179/255, blue: 255/255, alpha: 1.0), range: NSRange(location: 0, length: emailString.length))
        let endString = NSMutableAttributedString(string: " email address.")
        infoString.append(emailString)
        infoString.append(endString)
        infoLabel.attributedText = infoString

    }

    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
