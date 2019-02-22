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
    @IBOutlet weak var schoolLabel: UILabel!
    
    //MARK: Variables
    var starCount = 5
    var firstName = ""
    var lastName = ""
    var school = ""

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is editProfileScreen {
            let view = segue.destination as? editProfileScreen
            view?.firstName = firstName
            view?.lastName = lastName
            view?.school = school
            view?.starCount = starCount
        }
    }

    @IBAction func closeProfileView(_ sender: UIButton) {
    }
    
    @IBAction func openEditProfileView(_ sender: UIButton) {
    }
}
