//
//  targetFaceChoice.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/11/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class targetFaceChoice: UIViewController {

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var innerTenLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var singleSpotButton: UIButton!
    @IBOutlet weak var compoundSingleButton: UIButton!
    @IBOutlet weak var triangle3SpotButton: UIButton!
    @IBOutlet weak var vertical3SpotButton: UIButton!
    @IBOutlet weak var innerTenSwitch: UISwitch!
    
    
    //MARK: Variables
    let realm = try! Realm()
    var currRound = ScoringRound()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(realm.objects(ScoringRound.self))
        setUpViewLooks()
        if currRound.innerTen == "on" { innerTenSwitch.setOn(true, animated: false) }
        else { innerTenSwitch.setOn(false, animated: false)}
    }
    
    //MARK: Functions
    func setUpViewLooks() {
        //Set corner radii
        popUpView.layer.cornerRadius = 20
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        singleSpotButton.layer.cornerRadius = 10
        compoundSingleButton.layer.cornerRadius = 10
        triangle3SpotButton.layer.cornerRadius = 10
        vertical3SpotButton.layer.cornerRadius = 10
        
        //Set button borders
        if currRound.targetFace == "SingleSpot" {
            singleSpotButton.layer.borderWidth = 0.5
        } else if currRound.targetFace == "CompoundSingleSpot" {
            compoundSingleButton.layer.borderWidth = 0.5
        } else if currRound.targetFace == "Triangle3Spot" {
            triangle3SpotButton.layer.borderWidth = 0.5
        } else if currRound.targetFace == "Vertical3Spot" {
            vertical3SpotButton.layer.borderWidth = 0.5
        }
        singleSpotButton.layer.borderColor = UIColor.lightGray.cgColor
        compoundSingleButton.layer.borderColor = UIColor.lightGray.cgColor
        triangle3SpotButton.layer.borderColor = UIColor.lightGray.cgColor
        vertical3SpotButton.layer.borderColor = UIColor.lightGray.cgColor
        
        //Set image to not stretch in button
        singleSpotButton.imageView?.contentMode = .scaleAspectFit
        compoundSingleButton.imageView?.contentMode = .scaleAspectFit
        triangle3SpotButton.imageView?.contentMode = .scaleAspectFit
        vertical3SpotButton.imageView?.contentMode = .scaleAspectFit
    }
    
    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.modalTransitionStyle = .crossDissolve
            self.view.alpha = 0
        }, completion: nil)
        dismiss(animated: true)
    }
    
    @IBAction func targetTapped(_ sender: UIButton) {
        singleSpotButton.layer.borderWidth = 0
        compoundSingleButton.layer.borderWidth = 0
        triangle3SpotButton.layer.borderWidth = 0
        vertical3SpotButton.layer.borderWidth = 0
        var targetFace = ""
        switch sender.tag {
        case 0 :
            targetFace = "SingleSpot"
            singleSpotButton.layer.borderWidth = 0.5
        case 1 :
            targetFace = "CompoundSingleSpot"
            compoundSingleButton.layer.borderWidth = 0.5
        case 2 :
            targetFace = "Triangle3Spot"
            triangle3SpotButton.layer.borderWidth = 0.5
        case 3 :
            targetFace = "Vertical3Spot"
            vertical3SpotButton.layer.borderWidth = 0.5
        default:
            targetFace = "SingleSpot"
            singleSpotButton.layer.borderWidth = 0.5
        }
        try! realm.write {
            currRound.targetFace = targetFace
        }
    }

    @IBAction func switchTapped(_ sender: UISwitch) {
        var newTenPref = ""
        if sender.isOn == true { newTenPref = "on" }
        else { newTenPref = "off" }
        try! realm.write {
            currRound.innerTen = newTenPref
        }
    }
}
