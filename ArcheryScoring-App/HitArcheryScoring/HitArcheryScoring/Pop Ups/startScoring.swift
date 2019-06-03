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
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 20
        cancelButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        cancelButton.layer.cornerRadius = 10
        textScoringButton.layer.cornerRadius = 10
        targetScoringButton.layer.cornerRadius = 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func openTextScoring(_ sender: UIButton) {
    }
    
    @IBAction func openTargetScoring(_ sender: UIButton) {
    }
    
}
