//
//  editProfileScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class editProfileScreen: UIViewController {

    //MARK: Properties
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var editPicButton: UIButton!
    @IBOutlet weak var currentPicImage: UIImageView!
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
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserInfo()
        // Do any additional setup after loading the view.
    }
    
    func loadUserInfo() {
        if defaults.object(forKey: "FirstName") == nil {
            defaults.set(firstName, forKey: "FirstName")
            defaults.set(lastName, forKey: "LastName")
            defaults.set(school, forKey: "School")
        }
        let fullName = firstName + " " + lastName
        nameLabel.attributedText = NSAttributedString(string: fullName, attributes: [.underlineStyle: NSUnderlineStyle.single.rawValue])
        schoolLabel.text = school
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is profileScreen {
            let view = segue.destination as? profileScreen
            view?.firstName = firstName
            view?.lastName = lastName
            view?.school = school
        }
    }
    
    func updateUserDefaults() {
        defaults.set(firstName, forKey: "FirstName")
        defaults.set(lastName, forKey: "LastName")
        defaults.set(school, forKey: "School")
    }

    //MARK: Actions
    @IBAction func doneEditing(_ sender: UIButton) {
        updateUserDefaults()
    }
    
    @IBAction func changeProfilePic(_ sender: UIButton) {
    }
}
