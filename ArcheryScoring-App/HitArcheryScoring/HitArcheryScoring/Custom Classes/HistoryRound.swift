//
//  HistoryRound.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/8/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import RealmSwift

class HistoryRound : Object {
    
    @objc dynamic var roundTitle: String = ""
    @objc dynamic var time : String = ""
    @objc dynamic var date : String = ""
    @objc dynamic var arrowScores : [[String]] = [[""]]
    @objc dynamic var arrowLocations : [CGFloat]?
    @objc dynamic var runningScores : [Int] = []
    @objc dynamic var totalScore : Int = 0
    @objc dynamic var hits : Int = 0
    @objc dynamic var relativePR : Int = 0
    @objc dynamic var scoringType : String = ""
    @objc dynamic var targetFace : String = ""
    
    //Save function for writing object to realm
    func saveRound() -> Bool {
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(self)
            }
            return true
        } catch let error as NSError {
            print(">>> Realm error: ", error.localizedDescription)
            return false
        }
    }
    
//    init(roundTitle: String, time : String, date : String, arrowScores : [[String]], arrowLocations : [CGFloat], runningScores : [Int], totalScore : Int, hits : Int, relativePR : Int, scoringType : String, targetFace : String) {
//        self.roundTitle = roundTitle
//        self.time = time
//        self.date = date
//        self.arrowScores = arrowScores
//        self.arrowLocations = arrowLocations
//        self.runningScores = runningScores
//        self.totalScore = totalScore
//        self.hits = hits
//        self.relativePR = relativePR
//        self.scoringType = scoringType
//        self.targetFace = targetFace
//    }
    
    
}
