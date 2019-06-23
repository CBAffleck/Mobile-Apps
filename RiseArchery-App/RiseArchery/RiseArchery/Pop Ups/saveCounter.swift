//
//  saveCounter.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/22/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class saveCounter: UIViewController {

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    
    //MARK: Variables
    let realm = try! Realm()
    var count = 0
    var time = ""
    var date = ""
    var distance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        finishButton.layer.cornerRadius = 10
    }
    
    //MARK: Functions
    //Create and save a new arrow count history object
    func saveArrowCountHistory() {
        let round = HistoryArrowCount()
        
        round.numArrows = count
        round.distance = distance
        round.date = date
        round.time = time
        
        if round.saveArrowCount() {
            print("Arrow count saved!")
        } else {
            print("Could not save arrow count.")
        }
        
        //Update average for the practice round
        updateUserInfo()
    }
    
    //Add arrow count to user's total arrow count
    func updateUserInfo() {
        let currUser = realm.objects(UserInfo.self).first!
        try! realm.write {
            currUser.totalArrowsShot += count
        }
    }
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
        saveArrowCountHistory()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissDimView"), object: nil)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.modalTransitionStyle = .crossDissolve
            self.view.alpha = 0
        }, completion: nil)
        dismiss(animated: true)
    }
    

}
