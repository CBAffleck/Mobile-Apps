//
//  choosePractice.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class choosePractice: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var singleSpotButton: UIButton!
    @IBOutlet weak var compoundSingleButton: UIButton!
    @IBOutlet weak var triangle3SpotButton: UIButton!
    @IBOutlet weak var vertical3SpotButton: UIButton!
    @IBOutlet weak var innerTenSwitch: UISwitch!
    @IBOutlet weak var distanceControl: UISegmentedControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var popUpView: UIView!
    
    //MARK: Variables
    let realm = try! Realm()
    var round18 = PracticeRound()
    var round50 = PracticeRound()
    var round70 = PracticeRound()
    var currRound = PracticeRound()
    var innerTen = ""
    var targetFace = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        setRounds()
        setUpViewLooks()
        
        //Set inner ten switch position
        if innerTen == "on" { innerTenSwitch.setOn(true, animated: false) }
        else { innerTenSwitch.setOn(false, animated: false)}
        
        //Set button borders
        if targetFace == "SingleSpot" {
            singleSpotButton.layer.borderWidth = 0.5
        } else if targetFace == "CompoundSingleSpot" {
            compoundSingleButton.layer.borderWidth = 0.5
        } else if targetFace == "Triangle3Spot" {
            triangle3SpotButton.layer.borderWidth = 0.5
        } else if targetFace == "Vertical3Spot" {
            vertical3SpotButton.layer.borderWidth = 0.5
        }
    }
    
    //MARK: Functions
    func setRounds() {
        for round in realm.objects(PracticeRound.self) {
            if round.distance      == "18m" { round18 = round }
            else if round.distance == "50m" { round50 = round }
            else if round.distance == "70m" { round70 = round }
        }
    }
    
    func setUpViewLooks() {
        //Set corner radii
        popUpView.layer.cornerRadius = 20
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        startButton.layer.cornerRadius = 10
        singleSpotButton.layer.cornerRadius = 10
        compoundSingleButton.layer.cornerRadius = 10
        triangle3SpotButton.layer.cornerRadius = 10
        vertical3SpotButton.layer.cornerRadius = 10
        
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
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        if segue.destination is practiceScreen {
            let view = segue.destination as? practiceScreen
            view?.currRound = currRound
        }
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
        case 4 :
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
            print("Updated round target face!")
        }
    }
    
    @IBAction func switchTapped(_ sender: UISwitch) {
        var newTenPref = ""
        if sender.isOn == true { newTenPref = "on" }
        else { newTenPref = "off" }
        try! realm.write {
            currRound.innerTen = newTenPref
            print("Updated round inner ten setting!")
        }
    }
    
    @IBAction func controlChanged(_ sender: UISegmentedControl) {
        let index = sender.selectedSegmentIndex
        if index      == 0 { currRound = round18 }
        else if index == 1 { currRound = round50 }
        else if index == 2 { currRound = round70 }
    }
    
    @IBAction func startTapped(_ sender: UIButton) {
    }
    
}
