//
//  historyScreen.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/6/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class historyScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var historyTable: UITableView!
    @IBOutlet weak var historyTitle: UILabel!
    @IBOutlet weak var alertLabel: UILabel!
    
    
    //MARK: Variables
    let realm = try! Realm()
    var rounds : [HistoryRound] = []
    var practiceRounds : [HistoryPracticeRound] = []
    let sections = ["Scoring Rounds", "Practices"]
    //HistoryRound variables
    var roundTitle: String = ""
    var time : String = ""
    var date : String = ""
    var arrowScores : [[String]] = [[""]]
    var arrowLocations : [CGPoint]?
    var runningScores : [Int] = []
    var totalScore : Int = 0
    var hits : Int = 0
    var relativePR : Int = 0
    var scoringType : String = ""
    var targetFace : String = ""
    var endCount : Int = 0
    var arrowsPerEnd : Int = 0
    //Other Practice History Round variables
    var arrowCount : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "reloadData"), object: nil)

        // Do any additional setup after loading the view.
        makeRoundsArray()
        if !(rounds.count == 0) {
            alertLabel.isHidden = true
        }
        setUpTableView()
        historyTable.separatorStyle = .none
        historyTable.showsVerticalScrollIndicator = false
    }
    
    //Put objects into an array that cells can be made from
    func makeRoundsArray() {
        //Populate scoring history array
        let results = realm.objects(HistoryRound.self)
        for result in results {
            rounds.insert(result, at: 0)
        }
        //Populate practice history array
        let practices = realm.objects(HistoryPracticeRound.self)
        for practice in practices {
            practiceRounds.insert(practice, at: 0)
        }
    }
    
    func setUpTableView() {
        historyTable.delegate   = self
        historyTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCellID") as! sectionCell
        cell.setInfo(title: sections[section])
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 { return rounds.count }
        else            { return practiceRounds.count }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let round = rounds[indexPath.row]
            let cell  = tableView.dequeueReusableCell(withIdentifier: "historyCellID") as! historyCell
            cell.setInfo(round: round)
            return cell
        } else {
            let round = practiceRounds[indexPath.row]
            let cell  = tableView.dequeueReusableCell(withIdentifier: "practiceHistoryCellID") as! practiceHistoryCell
            cell.setInfo(round: round)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 { return 151 }
        else                      { return 113 }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let selectedRound = rounds[indexPath.row]
            
            //Convert List<Object> to [[String]]
            var tempScores: [[String]] = []
            for x in selectedRound.arrowScores {
                if selectedRound.arrowsPerEnd == 3 { tempScores.append([x.a1, x.a2, x.a3]) }
                else { tempScores.append([x.a1, x.a2, x.a3, x.a4, x.a5, x.a6]) }
            }
            
            //Convert List<Object> to [CGPoint]
            var tempPos: [CGPoint] = []
            for x in selectedRound.arrowLocations { tempPos.append(CGPoint(x: x.xPos, y: x.yPos)) }
            
            //Convert List<Int> to [Int]
            var tempRuns: [Int] = []
            for x in selectedRound.runningScores { tempRuns.append(x) }
            
            roundTitle     = selectedRound.roundTitle
            time           = selectedRound.time
            date           = selectedRound.date
            arrowScores    = tempScores
            arrowLocations = tempPos
            runningScores  = tempRuns
            totalScore     = selectedRound.totalScore
            hits           = selectedRound.hits
            relativePR     = selectedRound.relativePR
            scoringType    = selectedRound.scoringType
            targetFace     = selectedRound.targetFace
            endCount       = selectedRound.endCount
            arrowsPerEnd   = selectedRound.arrowsPerEnd
            performSegue(withIdentifier: "historyTargetSegue", sender: indexPath)
        } else {
            let selectedRound = practiceRounds[indexPath.row]
            roundTitle        = selectedRound.roundName
            time              = selectedRound.time
            date              = selectedRound.date
            arrowCount        = selectedRound.arrowScores.count
            targetFace        = selectedRound.targetFace
            performSegue(withIdentifier: "historyPracticeSegue", sender: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyTargetSegue" {
            let vc = segue.destination as? historyTarget
            vc?.roundTitle     = roundTitle
            vc?.time           = time
            vc?.date           = date
            vc?.arrowScores    = arrowScores
            vc?.arrowLocations = arrowLocations
            vc?.runningScores  = runningScores
            vc?.totalScore     = totalScore
            vc?.hits           = hits
            vc?.relativePR     = relativePR
            vc?.scoringType    = scoringType
            vc?.targetFace     = targetFace
            vc?.endCount       = endCount
            vc?.arrowsPerEnd   = arrowsPerEnd
        } else if segue.identifier == "historyPracticeSegue" {
            let vc = segue.destination as? practiceHistory
            vc?.roundTitle     = roundTitle
            vc?.time           = time
            vc?.date           = date
            vc?.arrowCount     = arrowCount
            vc?.targetFace     = targetFace
        }
    }
    
    @objc func reloadData() {
        historyTable.reloadData()
    }
}
