//
//  historyScreen.swift
//  HitArcheryScoring
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
    @IBOutlet weak var dimView: UIView!
    
    
    //MARK: Variables
    let realm = try! Realm()
    var rounds : [HistoryRound] = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pop up background dimming stuff
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
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
    
    //Put historyRound objects into an array that cells can be made from
    func makeRoundsArray() {
        let results = realm.objects(HistoryRound.self)
        for result in results {
            rounds.insert(result, at: 0)
        }
    }
    
    func setUpTableView() {
        historyTable.delegate = self
        historyTable.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rounds.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let round = rounds[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCellID") as! historyCell
        cell.setInfo(round: round)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 151
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        roundTitle = rounds[indexPath.row].roundTitle
        time = rounds[indexPath.row].time
        date = rounds[indexPath.row].date
        
        //Convert List<Object> to [[String]]
        var tempScores: [[String]] = []
        for x in rounds[indexPath.row].arrowScores {
            if rounds[indexPath.row].arrowsPerEnd == 3 {
                tempScores.append([x.a1, x.a2, x.a3])
            } else {
                tempScores.append([x.a1, x.a2, x.a3, x.a4, x.a5, x.a6])
            }
        }
        arrowScores = tempScores
        
        //Convert List<Object> to [CGPoint]
        var tempPos: [CGPoint] = []
        for x in rounds[indexPath.row].arrowLocations {
            tempPos.append(CGPoint(x: x.xPos, y: x.yPos))
        }
        arrowLocations = tempPos
        
        //Convert List<Int> to [Int]
        var tempRuns: [Int] = []
        for x in rounds[indexPath.row].runningScores {
            tempRuns.append(x)
        }
        runningScores = tempRuns
        totalScore = rounds[indexPath.row].totalScore
        hits = rounds[indexPath.row].hits
        relativePR = rounds[indexPath.row].relativePR
        scoringType = rounds[indexPath.row].scoringType
        targetFace = rounds[indexPath.row].targetFace
        endCount = rounds[indexPath.row].endCount
        arrowsPerEnd = rounds[indexPath.row].arrowsPerEnd
        performSegue(withIdentifier: "historyTargetSegue", sender: indexPath)
        animateIn()
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "historyTargetSegue" {
            let vc = segue.destination as? historyTarget
            vc?.roundTitle = roundTitle
            vc?.time = time
            vc?.date = date
            vc?.arrowScores = arrowScores
            vc?.arrowLocations = arrowLocations
            vc?.runningScores = runningScores
            vc?.totalScore = totalScore
            vc?.hits = hits
            vc?.relativePR = relativePR
            vc?.scoringType = scoringType
            vc?.targetFace = targetFace
            vc?.endCount = endCount
            vc?.arrowsPerEnd = arrowsPerEnd
        }
    }
    
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
    
    @objc func reloadData() {
        historyTable.reloadData()
    }
}
