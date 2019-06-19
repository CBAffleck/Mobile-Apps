//
//  deleteHistory.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/18/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class deleteHistory: UIViewController {

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoText: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    //MARK: Variables
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 20
        cancelButton.layer.cornerRadius = 10
        deleteButton.layer.cornerRadius = 10
    }
    
    //MARK: Functions
    func deleteHistory() {
        let historyRounds = realm.objects(HistoryRound.self)
        try! realm.write {
            realm.delete(historyRounds)
            print("History deleted")
            for round in realm.objects(ScoringRound.self) {
                round.roundNum = 1
                round.lastScored = "--"
                round.average = "0"
                round.pr = 0
            }
            print("Scoring round data reset")
        }
    }

    //MARK: Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func deleteTapped(_ sender: UIButton) {
        let feedbackGenerator = UIImpactFeedbackGenerator(style: .heavy)
        feedbackGenerator.impactOccurred()
        deleteHistory()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}
