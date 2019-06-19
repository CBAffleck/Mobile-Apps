//
//  startScoring.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class startScoring: UIViewController {

    //MARK: Properties
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var roundDescLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    @IBOutlet weak var textScoringButton: UIButton!
    @IBOutlet weak var targetScoringButton: UIButton!
    @IBOutlet weak var roundTitleLabel: UILabel!
    @IBOutlet weak var popUpView: UIView!
    
    //Mark: Variables
    var currRound = ScoringRound()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissScreen), name: NSNotification.Name(rawValue: "ClosePopUp"), object: nil)

        popUpView.layer.cornerRadius = 20
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cancelButton.layer.cornerRadius = 10
        textScoringButton.layer.cornerRadius = 10
        targetScoringButton.layer.cornerRadius = 10
        
        roundTitleLabel.text = currRound.roundName
        roundDescLabel.text = currRound.roundDescription
        averageLabel.text = "Average: " + currRound.average
        prLabel.text = "Personal Record: " + String(currRound.pr)
    }
    
    //MARK: Functions
    @objc func dismissScreen() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        dismiss(animated: false, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        if segue.destination is textScoring {
            let view = segue.destination as? textScoring
            view?.currRound = currRound
        } else if segue.destination is targetScoring {
            let view = segue.destination as? targetScoring
            view?.currRound = currRound
        }
    }
    
    //MARK: Actions
    @IBAction func closePopUp(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
    }
    
    @IBAction func openTextScoring(_ sender: UIButton) {
    }
    
    @IBAction func openTargetScoring(_ sender: UIButton) {
    }
    
}
