//
//  profileScreen.swift
//  RiseArchery
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
    @IBOutlet weak var chartView: ScoresChartView!
    @IBOutlet weak var settingsButton: UIButton!
    
    //MARK: Variables
    let realm = try! Realm()
    var currUser = UserInfo()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissPopUp), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        currUser             = realm.objects(UserInfo.self).first!
        nameLabel.text       = currUser.firstName + " " + currUser.lastName
        bowLabel.text        = "Arrows Shot: \(String(currUser.totalArrowsShot))"
        roundCountLabel.text = setRoundCountLabel()
        
        profilePicView.image              = loadImageFromDiskWith(fileName: currUser.profilePic)
        profilePicView.layer.cornerRadius = profilePicView.frame.size.height / 2
        profilePicView.clipsToBounds      = true
        
        chartView.contentMode = .scaleAspectFit
        settingsButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        
        editButton.addTarget(self, action: #selector(touchDown), for: [.touchDown, .touchDragEnter])
        editButton.addTarget(self, action: #selector(touchUp), for: [.touchUpInside, .touchDragExit, .touchCancel])
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        ScoresChartView.playAnimations()
    }

    //MARK: Functions
    @objc private func touchDown() {
        let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
        animator.addAnimations {
            self.profilePicView.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
            self.profileBorderImg.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        }
        animator.startAnimation()
    }
    
    @objc private func touchUp() {
        let params = UISpringTimingParameters(damping: 0.4, response: 0.2)
        let animator = UIViewPropertyAnimator(duration: 0, timingParameters: params)
        animator.addAnimations {
            self.profilePicView.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.profileBorderImg.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
        animator.startAnimation()
    }
    
    func setRoundCountLabel() -> String {
        let numRounds = realm.objects(HistoryRound.self).count
//        if numRounds == 1 { return String(numRounds) + " Round Scored" }
//        else { return String(numRounds) + " Rounds Scored" }
        return "Rounds Scored: \(String(numRounds))"
    }
    
    @objc func dismissPopUp() {
        //Set new target face icon on the round that was changed
        nameLabel.text = currUser.firstName + " " + currUser.lastName
//        bowLabel.text = currUser.bowType
        if currUser.profilePic == "EditProfile" {
            profilePicView.image = loadImageFromDiskWith(fileName: "EditProfile")
        } else { profilePicView.image = loadImageFromDiskWith(fileName: currUser.profilePic)}
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
    @IBAction func settingsTapped(_ sender: UIButton) {
    }
    
    
    
}
