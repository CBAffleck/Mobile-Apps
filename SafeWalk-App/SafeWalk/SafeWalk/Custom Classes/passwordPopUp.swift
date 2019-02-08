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
    @IBOutlet weak var requirementsView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: Variables
    var upperCase = true
    var lowerCase = true
    var number = true
    var specialChar = true
    var length = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requirementsView.text = "-one upper case letter\n-one lower case letter\n-one number\n-one special character\n-a minimum length of 8"
    }

    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
