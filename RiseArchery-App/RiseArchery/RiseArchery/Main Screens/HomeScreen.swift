//
//  HomeScreen.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class HomeScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var strongShotsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dimView: UIView!
    
    //MARK: Variables
    let realm = try! Realm()
    let defaults = UserDefaults.standard
    var currUser = UserInfo()
    var rounds: [ScoringRound] = []
    var tempRound = ScoringRound()
    var tempTen = ""
    var tempFace = ""
    var practice = PracticeRound()
    var lastTapped = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pop up background dimming stuff
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.setTargetIcons), name: NSNotification.Name(rawValue: "setTargets"), object: nil)
        
        setUpRealm()
        currUser = realm.objects(UserInfo.self).first!
        createRoundArray()
        setPracticeRound()
        setUpTableView()
        
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        
        self.hideKeyboardOnTap()
    }
    
    func setUpRealm() {
        //Set up scoring round data
        if realm.objects(ScoringRound.self).first != nil {
            //Do nothing since the scoring rounds have already been added
        } else {
            //Save target images to device so they don't take up memory every time the user scores with a target face
            saveImage(imageName: "SingleSpot", image: UIImage(named: "SingleSpot")!)
            saveImage(imageName: "CompoundSingleSpot", image: UIImage(named: "CompoundSingleSpot")!)
            saveImage(imageName: "Triangle3Spot", image: UIImage(named: "Triangle3Spot")!)
            saveImage(imageName: "Vertical3Spot", image: UIImage(named: "Vertical3Spot")!)
            
            //Save user defaults for language and distance type
            defaults.set("English", forKey: "Language")
            defaults.set("Metric (meters)", forKey: "DistanceUnit")
            defaults.set("Metric", forKey: "ScoringUnit")
            defaults.set(false, forKey: "isDarkMode")
            
            //Set 18m indoor scoring round and save to realm
            let indoorRound18m = ScoringRound()
            indoorRound18m.roundName = "18m Scoring Round"
            indoorRound18m.roundNum = 1
            indoorRound18m.distance = "18m"
            indoorRound18m.lastScored = "--"
            indoorRound18m.roundDescription = "10 ends, 3 arrows per end"
            indoorRound18m.average = "0"
            indoorRound18m.pr = 0
            indoorRound18m.targetFace = "SingleSpot"
            indoorRound18m.targetIcon = "SingleSpotIcon"
            indoorRound18m.innerTen = "off"
            indoorRound18m.endCount = 10
            indoorRound18m.arrowsPerEnd = 3
            if indoorRound18m.saveScoringRound() { print("18M Scoring round saved!") }
            else { print("Could not save scoring round.") }
            
            //Set 50m outdoor scoring round and save to realm
            let outdoorRound50m = ScoringRound()
            outdoorRound50m.roundName = "50m Scoring Round"
            outdoorRound50m.roundNum = 1
            outdoorRound50m.distance = "50m"
            outdoorRound50m.lastScored = "--"
            outdoorRound50m.roundDescription = "6 ends, 6 arrows per end"
            outdoorRound50m.average = "0"
            outdoorRound50m.pr = 0
            outdoorRound50m.targetFace = "SingleSpot"
            outdoorRound50m.targetIcon = "SingleSpotIcon"
            outdoorRound50m.innerTen = "off"
            outdoorRound50m.endCount = 6
            outdoorRound50m.arrowsPerEnd = 6
            if outdoorRound50m.saveScoringRound() { print("50M Scoring round saved!") }
            else { print("Could not save scoring round.") }
            
            //Set 70m outdoor scoring round and save to realm
            let outdoorRound70m = ScoringRound()
            outdoorRound70m.roundName = "70m Scoring Round"
            outdoorRound70m.roundNum = 1
            outdoorRound70m.distance = "70m"
            outdoorRound70m.lastScored = "--"
            outdoorRound70m.roundDescription = "6 ends, 6 arrows per end"
            outdoorRound70m.average = "0"
            outdoorRound70m.pr = 0
            outdoorRound70m.targetFace = "SingleSpot"
            outdoorRound70m.targetIcon = "SingleSpotIcon"
            outdoorRound70m.innerTen = "off"
            outdoorRound70m.endCount = 6
            outdoorRound70m.arrowsPerEnd = 6
            if outdoorRound70m.saveScoringRound() { print("70M Scoring round saved!") }
            else { print("Could not save scoring round.") }
        }
        
        //Set up user info
        if realm.objects(UserInfo.self).first != nil {
            //Do nothing since the user's info has already been set up
        } else {
            let newUser = UserInfo()
            newUser.firstName = "First"
            newUser.lastName = "Last"
            newUser.bowType = "Olympic Recurve"
            newUser.profilePic = "EditProfile"
            newUser.totalScoredRounds = 0
            newUser.languagePref = "English"
            if newUser.saveUser() { print("New user saved!") }
            else { print("Could not save new user info.") }
            saveImage(imageName: "EditProfile", image: UIImage(named: "EditProfile")!)
        }
        
        if realm.objects(PracticeRound.self).first != nil {
            //Do nothing since info is already set up
        } else {
            //Set 18m practice round default
            let practiceRound18m = PracticeRound()
            practiceRound18m.roundName = "18m Practice Round"
            practiceRound18m.roundNum = 1
            practiceRound18m.distance = "18m"
            practiceRound18m.lastPractice = "--"
            practiceRound18m.average = "0"
            practiceRound18m.targetFace = "SingleSpot"
            practiceRound18m.innerTen = "off"
            if practiceRound18m.savePracticeRound() { print("18M Practice round saved!") }
            else { print("Could not save practice round.") }

            //Set 50m practice round default
            let practiceRound50m = PracticeRound()
            practiceRound50m.roundName = "50m Practice Round"
            practiceRound50m.roundNum = 1
            practiceRound50m.distance = "50m"
            practiceRound50m.lastPractice = "--"
            practiceRound50m.average = "0"
            practiceRound50m.targetFace = "SingleSpot"
            practiceRound50m.innerTen = "off"
            if practiceRound50m.savePracticeRound() { print("50M Practice round saved!") }
            else { print("Could not save practice round.") }

            //Set 70m practice round default
            let practiceRound70m = PracticeRound()
            practiceRound70m.roundName = "70m Practice Round"
            practiceRound70m.roundNum = 1
            practiceRound70m.distance = "70m"
            practiceRound70m.lastPractice = "--"
            practiceRound70m.average = "0"
            practiceRound70m.targetFace = "SingleSpot"
            practiceRound70m.innerTen = "off"
            if practiceRound70m.savePracticeRound() { print("70M Practice round saved!") }
            else { print("Could not save practice round.") }
        }
    }
    
    func createRoundArray() {
        let results = realm.objects(ScoringRound.self)
        for result in results {
            rounds.append(result)
        }
    }
    
    func setPracticeRound() {
        for round in realm.objects(PracticeRound.self) {
            if round.distance == "18m" { practice = round }
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return rounds.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "practiceCellID") as! practiceCell
            cell.delegate = self
            return cell
        } else {
            let round = rounds[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! ScoringRoundCell
            cell.setInfo(round: round)
            cell.targetButton.tag = indexPath.row
            cell.delegate = self
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 188
        } else {
            return 151
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            //Do nothing, because button delegates are what prompt segues
            tableView.deselectRow(at: indexPath, animated: false)
        } else {
            let cell = self.tableView.cellForRow(at: indexPath) as! ScoringRoundCell
            tempRound = cell.roundItem
            performSegue(withIdentifier: "tableToPopUpSegue", sender: indexPath)
            animateIn()
            tableView.deselectRow(at: indexPath, animated: false)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToPopUpSegue" {
            let vc = segue.destination as? startScoring
            vc?.currRound = tempRound
        } else if segue.identifier == "mainToTargetChoiceID" {
            let vc = segue.destination as? targetFaceChoice
            vc?.currRound = tempRound
            vc?.innerTen = tempTen
            vc?.targetFace = tempFace
        } else if segue.identifier == "mainToPracticeSegue" {
            let vc = segue.destination as? choosePractice
            vc?.innerTen = practice.innerTen
            vc?.targetFace = practice.targetFace
            vc?.currRound = practice
        }
    }
    
    //Dim background when pop up appears
    func animateIn() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.isHidden = false
            self.dimView.alpha = 1
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.alpha = 0
        })
        self.dimView.isHidden = true
    }
    
    @objc func dismissEffect() {
        animateOut()
    }
    
    @objc func setTargetIcons() {
        animateOut()
        //Set new target face icon on the round that was changed
        let indexPath = NSIndexPath(row: lastTapped, section: 1) as IndexPath
        let cell = self.tableView.cellForRow(at: indexPath) as! ScoringRoundCell
        cell.targetButton.setImage(UIImage(named: rounds[lastTapped].targetFace + "Icon"), for: .normal)
    }
    
    @objc func reloadData() {
        tableView.reloadData()
    }
    
}

extension HomeScreen: ScoringCellDelegate {
    func didTapToScoring(row: Int) {
        lastTapped = row
        let indexPath = NSIndexPath(row: row, section: 1) as IndexPath
        let cell = self.tableView.cellForRow(at: indexPath) as! ScoringRoundCell
        tempRound = cell.roundItem
        tempTen = cell.roundItem.innerTen
        tempFace = cell.roundItem.targetFace
        performSegue(withIdentifier: "mainToTargetChoiceID", sender: indexPath)
        animateIn()
    }
}

extension HomeScreen: PracticeCellDelegate {
    func didTapToPractice() {
        let indexPath = IndexPath(row: 0, section: 0)
        performSegue(withIdentifier: "mainToPracticeSegue", sender: indexPath)
        animateIn()
    }
    
    func didTapToArrowCount() {
        let indexPath = IndexPath(row: 0, section: 0)
        performSegue(withIdentifier: "mainToCounterSegue", sender: indexPath)
    }
    
    
}

extension UIViewController {
    func hideKeyboardOnTap() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
