//
//  RealmClasses.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/8/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import RealmSwift

//Main realm object that stores all the info for a scoring round once the user finishes scoring
class HistoryRound : Object {
    
    @objc dynamic var roundTitle: String = ""
    @objc dynamic var time : String = ""
    @objc dynamic var date : String = ""
    var arrowScores = List<ArrowEndScores>()
    var arrowLocations = List<ArrowPos>()
    var runningScores = List<Int>()
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
}

//Class used to saved arrowEndScores as end objects that have 3 arrows each, which then go into the new arrowEndScores list to work with realm
class ArrowEndScores : Object {
    
    @objc dynamic var a1: String = ""
    @objc dynamic var a2: String = ""
    @objc dynamic var a3: String = ""
}

//Can't save CGPoints in realm, so instead CGPoints are saved as ArrowPos objects with an x and y component, so they can easily be converted back to a CGPoint
class ArrowPos : Object {
    
    @objc dynamic var xPos: Double = 0
    @objc dynamic var yPos: Double = 0
}

//Scoring round object to be saved in realm and provide easy access to round details
class ScoringRound : Object {
    
    @objc dynamic var roundName: String = ""
    @objc dynamic var roundNum: Int = 1
    @objc dynamic var distance: String = ""
    @objc dynamic var lastScored: String = ""
    @objc dynamic var roundDescription: String = ""
    @objc dynamic var average: String = ""
    @objc dynamic var pr: Int = 0
    @objc dynamic var targetFace: String = ""
    @objc dynamic var endCount: Int = 0
    @objc dynamic var arrowsPerEnd: Int = 0
    var pastScores = List<Int>()
    
    //Save function for writing object to realm
    func saveScoringRound() -> Bool {
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
}
