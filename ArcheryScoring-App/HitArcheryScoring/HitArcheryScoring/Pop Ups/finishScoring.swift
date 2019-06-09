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
    var aScores: [[String]] = []
    var totalScore = 0
    var hits = 0
    var endCount = 0
    var endTots: [Int] = []
    var running: [Int] = []
    var roundNum = 1                    //Round number in users history, pulled from realm
    var headerTitle = ""
    var timerValue = ""
    var startDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        finishView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        finishButton.layer.cornerRadius = 10
        calcEndTots()
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
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
        
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        dismiss(animated: true)
    }
    

}
