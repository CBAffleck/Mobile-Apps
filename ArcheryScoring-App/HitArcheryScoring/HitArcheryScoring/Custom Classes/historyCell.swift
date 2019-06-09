//
//  historyCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/8/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class historyCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var roundTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var avgArrowLabel: UILabel!
    
    
    //MARK: Variables
    var historyItem : HistoryRound!
    var roundTitle: String?
    var time : String?
    var date : String?
    var arrowScores : [[String]]?
    var arrowLocations : [CGPoint]?
    var runningScores : [Int]?
    var totalScore : Int?
    var hits : Int?
    var relativePR : Int?
    var scoringType : String?
    var targetFace : String?

    func setInfo(round: HistoryRound) {
        //Set variables from Realm object
        historyItem = round
        self.roundTitle = round.roundTitle
        self.time = round.time
        self.date = round.date
        
        var tempScores: [[String]] = []
        for x in round.arrowScores {
            tempScores.append([x.a1, x.a2, x.a3])
        }
        self.arrowScores = tempScores
        
        var tempPos: [CGPoint] = []
        for x in round.arrowLocations {
            tempPos.append(CGPoint(x: x.xPos, y: x.yPos))
        }
        self.arrowLocations = tempPos
        
        var tempRuns: [Int] = []
        for x in round.runningScores {
            tempRuns.append(x)
        }
        self.runningScores = tempRuns
        self.totalScore = round.totalScore
        self.hits = round.hits
        self.relativePR = round.relativePR
        self.scoringType = round.scoringType
        self.targetFace = round.targetFace
        
        //Set labels in cell
        dateLabel.text = round.date
        scoreLabel.text = "Score: " + String(round.totalScore)
        hitsLabel.text = "Hits: " + String(round.hits)
        roundTitleLabel.text = round.roundTitle
        avgArrowLabel.text = "Average Arrow: " + String(format: "%0.2f", Float(round.totalScore) / 30.0)
        
        //Setup cell layout details
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 0.75
        cellView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
    }
    
}
