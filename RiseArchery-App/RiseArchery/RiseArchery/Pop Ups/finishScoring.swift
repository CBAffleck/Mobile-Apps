//
//  finishScoring.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class finishScoring: UIViewController {

    //MARK: Properties
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: Variables
    let realm = try! Realm()
    let round = HistoryRound()
    var currRound = ScoringRound()
    var practiceRound = PracticeRound()
    var practiceHistory = HistoryPracticeRound()
    var aScores: [[String]] = []
    var aLocations: [CGPoint] = []
    var arrows: [Int] = []
    var totalScore = 0
    var hits = 0
    var endTots: [Int] = []
    var running: [Int] = []
    var headerTitle = ""
    var timerValue = ""
    var startDate = ""
    var scoringType = ""
    let defaults = UserDefaults.standard
    var targetImage = UIImage()
    var roundNum = 0
    var imgCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissScreen), name: NSNotification.Name(rawValue: "CloseFinish"), object: nil)
        
        finishView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        finishButton.layer.cornerRadius = 10
        if scoringType == "practice" { finishLabel.text = "Finish Practice?" }
        if scoringType != "practice" { calcEndTots() }
    }
    
    //MARK: Functions
    //Determine which scoring round is being scored
    func updatedRoundInfo(round : HistoryRound) {
        let currUser = realm.objects(UserInfo.self).first!
        try! realm.write {
            round.relativePR = currRound.pr
            currRound.pastScores.append(totalScore)
            currRound.average = String(format: "%0.2f", Float(currRound.pastScores.sum()) / Float(currRound.roundNum))
            currRound.roundNum += 1
            currRound.lastScored = startDate
            currRound.pr = max(currRound.pr, totalScore)
            currUser.totalScoredRounds += 1
        }
    }
    
    func updatePracticeInfo() {
        let currUser = realm.objects(UserInfo.self).first!
        try! realm.write {
            practiceRound.average = String(format: "%0.2f", Float(currRound.pastScores.sum()) / Float(practiceRound.roundNum))
            practiceRound.roundNum += 1
            practiceRound.lastPractice = startDate
            currUser.totalPracticeRounds += 1
        }
    }
    
    func calcEndTots() {
        for end in aScores {
            var lastRun = 0
            if !running.isEmpty { lastRun = running.last! }
            var endTot = 0
            for a in end {
                if a == "X" {
                    endTot += 10
                }
                else if a == "M" { endTot += 0}
                else {
                    endTot += Int(a) ?? 0
                }
            }
            endTots.append(endTot)
            lastRun += endTot
            running.append(lastRun)
        }
    }
    
    func saveRound() {
        //Assign values from scoring round to a HistoryRound object
        let aScoresList = List<ArrowEndScores>()
        for x in aScores {
            let end = ArrowEndScores()
            end.a1 = x[0]
            end.a2 = x[1]
            end.a3 = x[2]
            if currRound.arrowsPerEnd == 6 {
                end.a4 = x[3]
                end.a5 = x[4]
                end.a6 = x[5]
            }
            aScoresList.append(end)
        }
        round.arrowScores = aScoresList
        
        let aPosList = List<ArrowPos>()
        for x in aLocations {
            let pos = ArrowPos()
            pos.xPos = Double(x.x)
            pos.yPos = Double(x.y)
            aPosList.append(pos)
        }
        if scoringType == "target" { round.arrowLocations = aPosList }
        round.totalScore = totalScore
        round.hits = hits
        round.roundTitle = headerTitle
        round.time = timerValue
        round.date = startDate
        
        let runList = List<Int>()
        for x in running {
            runList.append(x)
        }
        round.runningScores = runList
        round.scoringType = scoringType
        round.targetFace = currRound.targetFace
        round.endCount = currRound.endCount
        round.arrowsPerEnd = currRound.arrowsPerEnd
        round.roundNum = currRound.roundNum
        round.distance = currRound.distance
        round.innerTen = currRound.innerTen
        
        if round.saveRound() {
            print("Scoring round saved!")
        } else {
            print("Could not save scoring round.")
        }
        
        //Update average for the scoring round
        updatedRoundInfo(round: round)
    }
    
    //Create and save a new practice history round
    func savePracticeHistory() {
        let aScoresList = List<Int>()
        for x in arrows {
            aScoresList.append(x)
        }
        practiceHistory.arrowScores = aScoresList
        
        let aPosList = List<ArrowPos>()
        for x in aLocations {
            let pos = ArrowPos()
            pos.xPos = Double(x.x)
            pos.yPos = Double(x.y)
            aPosList.append(pos)
        }
        practiceHistory.arrowLocations = aPosList
        
        practiceHistory.totalScore = totalScore
        practiceHistory.hits = hits
        practiceHistory.roundName = headerTitle
        practiceHistory.time = timerValue
        practiceHistory.date = startDate
        
        let runList = List<Int>()
        for x in running {
            runList.append(x)
        }
        practiceHistory.targetFace = practiceRound.targetFace
        practiceHistory.roundNum = practiceRound.roundNum
        practiceHistory.distance = practiceRound.distance
        practiceHistory.innerTen = practiceRound.innerTen
        
        if practiceHistory.saveHistoryPracticeRound() {
            print("Practice round saved!")
        } else {
            print("Could not save practice round.")
        }
        
        //Update average for the practice round
        updatePracticeInfo()
    }
    
    @objc func dismissScreen() {
        dismiss(animated: true, completion: {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ClosePopUp"), object: nil)
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CloseWindow"), object: nil)
        })
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "finishToCongratsSegue" {
            let vc = segue.destination as? congratsScreen
            vc?.inScores = aScores
            vc?.inTotal = totalScore
            vc?.inHits = hits
            vc?.inEndCount = currRound.endCount
            vc?.inArrowsPerEnd = currRound.arrowsPerEnd
            vc?.inEndTots = endTots
            vc?.inRunning = running
            vc?.roundNum = roundNum
            vc?.headerTitle = headerTitle
            vc?.time = timerValue
            vc?.date = startDate
        } else if segue.identifier == "finishToPracticeCongratsSegue" {
            let vc = segue.destination as? practiceCongrats
            vc?.roundNum = roundNum
            vc?.headerTitle = headerTitle
            vc?.time = timerValue
            vc?.date = startDate
            vc?.inArrows = arrows
            vc?.targetImage = targetImage
        }
    }
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
        if scoringType == "target" {
            saveImage(imageName: currRound.targetFace + String(headerTitle.prefix(3)) + String(roundNum), image: targetImage)
            saveRound()
        } else if scoringType == "practice" {
            saveImage(imageName: practiceRound.targetFace + String(headerTitle.prefix(3)) + String(roundNum), image: targetImage)
            savePracticeHistory()
        }
        
        if (scoringType == "target" || scoringType == "practice") && imgCount > 1 {
            for i in 1...imgCount - 1 {
                removeImage(imageName: "temp" + String(i))
            }
        }
        if scoringType == "practice" { performSegue(withIdentifier: "finishToPracticeCongratsSegue", sender: self) }
        else { performSegue(withIdentifier: "finishToCongratsSegue", sender: self) }
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.modalTransitionStyle = .crossDissolve
            self.view.alpha = 0
        }, completion: nil)
        dismiss(animated: true)
    }
    

}
