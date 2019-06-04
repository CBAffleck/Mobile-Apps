//
//  HomeScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: Properties
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var scoringIcon: UIImageView!
    @IBOutlet weak var historyIcon: UIImageView!
    @IBOutlet weak var scoringLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var scoringButton: UIButton!
    @IBOutlet weak var strongShotsLabel: UILabel!
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    var rounds: [ScoringRound] = []
    var tempTitle = ""
    var tempDesc = ""
    var tempAvg = ""
    var tempPR = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        createRoundArray()
        setUpTableView()
        tableView.separatorColor = UIColor.white
    }
    
    func createRoundArray() {
        let indoorRound18m = ScoringRound(title: "18m Scoring Round", lastScored: "Last scored: 2 days ago", description: "10 ends, 3 arrows per end", average: "Average: 265", best: "Personal Record: 275")
        rounds.append(indoorRound18m)
        
        let outdoorRound70m = ScoringRound(title: "70m Scoring Round", lastScored: "Last scored: 10 days ago", description: "6 ends, 6 arrows per end", average: "Average: 275", best: "Personal Record: 305")
        rounds.append(outdoorRound70m)
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
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tempTitle = rounds[indexPath.row].title
        tempDesc = rounds[indexPath.row].description
        tempAvg = rounds[indexPath.row].average
        tempPR = rounds[indexPath.row].best
        performSegue(withIdentifier: "tableToPopUpSegue", sender: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tableToPopUpSegue" {
            let vc = segue.destination as? startScoring
            vc?.rTitle = tempTitle
            vc?.rDesc = tempDesc
            vc?.rAvg = tempAvg
            vc?.rBest = tempPR
        }
    }
    
    //MARK: Actions
    @IBAction func toProfileScreen(_ sender: UIButton) {
    }
    
    @IBAction func toHistoryScreen(_ sender: UIButton) {
    }
    
    @IBAction func toScoringScreen(_ sender: UIButton) {
    }
    
}

class ScoringRound {
    var title: String
    var lastScored: String
    var description: String
    var average: String
    var best: String
    
    init(title: String, lastScored: String, description: String, average: String, best: String) {
        self.title = title
        self.lastScored = lastScored
        self.description = description
        self.average = average
        self.best = best
    }
}

extension HomeScreen: ScoringCellDelegate {
    func didTapToScoring() {
        let popUpStoryboard = UIStoryboard(name: "startScoring", bundle: nil)
        let popUp = popUpStoryboard.instantiateViewController(withIdentifier: "startScoringID") as! startScoring
        popUp.modalTransitionStyle = .crossDissolve
        popUp.modalPresentationStyle = .overCurrentContext
        popUp.rTitle = tempTitle
        self.present(popUp, animated: true, completion: nil)
    }
}
