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
    @IBOutlet weak var signOutButton: UIButton!
    
    //MARK: Variables
    var starCount = 5
    var firstName = "firstname"
    var lastName = "lastname"
    var school = "school"
    let defaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
    }
    
    func loadUserInfo() {
        if defaults.object(forKey: "FirstName") == nil {
            defaults.set(firstName, forKey: "FirstName")
            defaults.set(lastName, forKey: "LastName")
            defaults.set(school, forKey: "School")
        } else {
            nameLabel.text = defaults.string(forKey: "FirstName")! + " " + defaults.string(forKey: "LastName")!
            schoolLabel.text = defaults.string(forKey: "School")!
            firstName = defaults.string(forKey: "FirstName")!
            lastName = defaults.string(forKey: "LastName")!
            school = defaults.string(forKey: "School")!
        }
        if defaults.bool(forKey: "FirstSignIn") == true {
            defaults.set(false, forKey: "FirstSignIn")
            closeButton.isHidden = true
            closeButton.isEnabled = false
        } else {
            signOutButton.isHidden = true
            signOutButton.isEnabled = false
        }
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
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
    @IBAction func openEditProfileView(_ sender: UIButton) {
    }
}
