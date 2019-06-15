//
//  profileScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/6/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class profileScreen: UIViewController {

    //MARK: Properties
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var profileBorderImg: UIImageView!
    @IBOutlet weak var profilePicView: UIImageView!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bowLabel: UILabel!
    @IBOutlet weak var roundCountLabel: UILabel!
    
    //MARK: Variables
    let realm = try! Realm()
    var currUser = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currUser = realm.objects(UserInfo.self).first!
        nameLabel.text = currUser.firstName + " " + currUser.lastName
        bowLabel.text = currUser.bowType
        roundCountLabel.text = setRoundCountLabel()
    }

    //MARK: Functions
    func setRoundCountLabel() -> String {
        let numRounds = realm.objects(HistoryRound.self).count
        if numRounds == 1 { return String(numRounds) + " Round Scored" }
        else { return String(numRounds) + " Rounds Scored" }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "profileToEditSegue" {
            let vc = segue.destination as? editProfile
            vc?.currUser = currUser
        }
    }

    //MARK: Actions
    @IBAction func tappedEdit(_ sender: UIButton) {
    }
    
    
    
}
