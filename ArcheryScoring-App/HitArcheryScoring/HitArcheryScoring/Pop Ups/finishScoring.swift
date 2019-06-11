//
//  finishScoring.swift
//  HitArcheryScoring
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
    var aScores: [[String]] = []
    var aLocations: [CGPoint] = []
    var totalScore = 0
    var hits = 0
    var endTots: [Int] = []
    var running: [Int] = []
    var roundNum = 0                    //Round number in users history, pulled from realm
    var headerTitle = ""
    var roundName = ""
    var timerValue = ""
    var startDate = ""
    var scoringType = ""
    var targetFace = ""
    let defaults = UserDefaults.standard
    var targetImage = UIImage()
    var endCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        finishView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        finishButton.layer.cornerRadius = 10
        calcEndTots()
    }
    
    //MARK: Functions
    //Determine which scoring round is being scored
    func updatedRoundInfo(round : HistoryRound) {
        var currRound = ScoringRound()
        for result in realm.objects(ScoringRound.self) {
            print(result)
            if result.roundName == roundName {
                currRound = result
                print("prevRound")
                print(currRound)
                try! realm.write {
                    round.relativePR = currRound.pr
                    currRound.pastScores.append(totalScore)
                    currRound.average = String(format: "%0.2f", Float(currRound.pastScores.sum()) / Float(roundNum))
                    currRound.roundNum += 1
                    currRound.lastScored = startDate
                    currRound.pr = max(currRound.pr, totalScore)
                }
                print("updatedRound")
                print(currRound)
                break
            }
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
        round.targetFace = targetFace
        
        if round.saveRound() {
            print("Scoring round saved!")
        } else {
            print("Could not save scoring round.")
        }
        
        //Update average for the scoring round
        updatedRoundInfo(round: round)
    }
    
    //Save target image to documents folder with a filename equal to the target face + distance + roundNum
    func saveImage(imageName : String, image : UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        
        let fileName = imageName
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        //Check if file exists, remove if so
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(at: fileURL)
                print("Removed old image")
            } catch let removeError {
                print("Couldn't remove file at path ", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("Error saving image with error ", error)
        }
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
            vc?.inEndCount = endCount
            vc?.inEndTots = endTots
            vc?.inRunning = running
            vc?.roundNum = roundNum
            vc?.headerTitle = headerTitle
            vc?.time = timerValue
            vc?.date = startDate
        }
    }
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
        saveRound()
        if scoringType == "target" {
            saveImage(imageName: targetFace + String(headerTitle.prefix(3)) + String(roundNum), image: targetImage)
        }
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        dismiss(animated: true)
    }
    

}
