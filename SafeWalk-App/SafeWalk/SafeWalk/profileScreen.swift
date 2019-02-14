//
//  profileScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class profileScreen: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var star1: UIImageView!
    @IBOutlet weak var star2: UIImageView!
    @IBOutlet weak var star3: UIImageView!
    @IBOutlet weak var star4: UIImageView!
    @IBOutlet weak var star5: UIImageView!
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func closeProfileView(_ sender: UIButton) {
    }
    
    @IBAction func openEditProfileView(_ sender: UIButton) {
    }
}
