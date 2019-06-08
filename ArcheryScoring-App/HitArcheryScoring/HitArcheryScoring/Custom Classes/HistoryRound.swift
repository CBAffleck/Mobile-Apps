//
//  HistoryRound.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/8/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import Foundation
import UIKit

class HistoryRound {
    
    var roundTitle: String
    var time : String
    var date : String
    var arrowScores : [[String]]
    var arrowLocations : [CGFloat]
    var runningScores : [Int]
    var totalScore : Int
    var hits : Int
    var relativePR : Int
    var scoringType : String
    var targetFace : String
    
    init(roundTitle: String, time : String, date : String, arrowScores : [[String]], arrowLocations : [CGFloat], runningScores : [Int], totalScore : Int, hits : Int, relativePR : Int, scoringType : String, targetFace : String) {
        self.roundTitle = roundTitle
        self.time = time
        self.date = date
        self.arrowScores = arrowScores
        self.arrowLocations = arrowLocations
        self.runningScores = runningScores
        self.totalScore = totalScore
        self.hits = hits
        self.relativePR = relativePR
        self.scoringType = scoringType
        self.targetFace = targetFace
    }
    
    
}
