//
//  HomeScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var scoringIcon: UIImageView!
    @IBOutlet weak var historyIcon: UIImageView!
    @IBOutlet weak var scoringLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var scoringButton: UIButton!
    @IBOutlet weak var lastScoredLabel: UILabel!
    @IBOutlet weak var averageLabel: UILabel!
    @IBOutlet weak var prLabel: UILabel!
    @IBOutlet weak var scoringPopUpButton: UIButton!
    @IBOutlet weak var scoringRoundView18m: UIView!
    @IBOutlet weak var contentView: UIView!
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        scoringRoundView18m.layer.cornerRadius = 20
        scoringRoundView18m.layer.borderWidth = 0.5
        scoringRoundView18m.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        scoringRoundView18m.frame.size.width = UIScreen.main.bounds.width - 40
        
        
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
    @IBAction func toProfileScreen(_ sender: UIButton) {
    }
    @IBAction func toHistoryScreen(_ sender: UIButton) {
    }
    @IBAction func toScoringScreen(_ sender: UIButton) {
    }
    @IBAction func openScoringPopUp(_ sender: UIButton) {
    }
    
}
