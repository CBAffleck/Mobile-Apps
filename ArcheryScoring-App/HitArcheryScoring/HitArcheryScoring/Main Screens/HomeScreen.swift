//
//  HomeScreen.swift
//  HitArcheryScoring
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
    var rounds: [ScoringRound] = []
    var tempTitle = ""
    var tempDesc = ""
    var tempAvg = ""
    var tempPR = ""
    var tempRound = ScoringRound()
    var tempTen = ""
    var tempFace = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pop up background dimming stuff
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        setUpRealm()
        createRoundArray()
        setUpTableView()
        tableView.separatorStyle = .none
        self.hideKeyboardOnTap()
    }
    
    func setUpRealm() {
        //Set up scoring round data
        if realm.objects(ScoringRound.self).first != nil {
            //Do nothing since the scoring rounds have already been added
        } else {
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
            indoorRound18m.innerTen = "off"
            indoorRound18m.endCount = 10
            indoorRound18m.arrowsPerEnd = 10
            if indoorRound18m.saveScoringRound() { print("Scoring round saved!") }
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
            outdoorRound70m.innerTen = "off"
            outdoorRound70m.endCount = 6
            outdoorRound70m.arrowsPerEnd = 6
            if outdoorRound70m.saveScoringRound() { print("Scoring round saved!") }
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
            newUser.totalScoredRounds = 0
            newUser.languagePref = "English"
            if newUser.saveUser() { print("New user saved!") }
            else { print("Could not save new user info.") }
        }
    }
    
    func createRoundArray() {
        let results = realm.objects(ScoringRound.self)
        for result in results {
            rounds.append(result)
        }
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let round = rounds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId") as! ScoringRoundCell
        cell.setInfo(round: round)
        cell.targetButton.tag = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tempTitle = rounds[indexPath.row].roundName
        tempDesc = rounds[indexPath.row].roundDescription
        tempAvg = "Average: " + rounds[indexPath.row].average
        tempPR = "Personal Record: " + String(rounds[indexPath.row].pr)
        performSegue(withIdentifier: "tableToPopUpSegue", sender: indexPath)
        animateIn()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToPopUpSegue" {
            let vc = segue.destination as? startScoring
            vc?.rTitle = tempTitle
            vc?.rDesc = tempDesc
            vc?.rAvg = tempAvg
            vc?.rBest = tempPR
        } else if segue.identifier == "mainToTargetChoiceID" {
            let vc = segue.destination as? targetFaceChoice
            vc?.currRound = tempRound
            vc?.innerTen = tempTen
            vc?.targetFace = tempFace
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
        //Set new target face icon on the round that was changed
        for x in 0...rounds.count - 1 {
            let indexPath = NSIndexPath(row: x, section: 0) as IndexPath
            let cell = self.tableView.cellForRow(at: indexPath) as! ScoringRoundCell
            cell.targetButton.setImage(UIImage(named: rounds[x].targetFace + "Icon"), for: .normal)
        }
    }
}

extension HomeScreen: ScoringCellDelegate {
    func didTapToScoring(row: Int) {
        let indexPath = NSIndexPath(row: row, section: 0) as IndexPath
        let cell = self.tableView.cellForRow(at: indexPath) as! ScoringRoundCell
        tempRound = cell.roundItem
        tempTen = cell.roundItem.innerTen
        tempFace = cell.roundItem.targetFace
        performSegue(withIdentifier: "mainToTargetChoiceID", sender: indexPath)
        animateIn()
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

