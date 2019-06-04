//
//  ScoringRoundCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

protocol ScoringCellDelegate {
    func didTapToScoring(title: String, lastScored: String, desc: String, avg: String, pr: String)
}

class ScoringRoundCell: UITableViewCell {

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    var delegate: ScoringCellDelegate?
    var roundItem: ScoringRound!

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastScoredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var perLabel: UILabel!
    
    func setInfo(round: ScoringRound) {
        roundItem = round
        titleLabel.text = round.title
        lastScoredLabel.text = round.lastScored
        descriptionLabel.text = round.description
        avgLabel.text = round.average
        perLabel.text = round.best
    }
    
    @IBAction func toScoringTapped(_ sender: UIButton) {
        delegate?.didTapToScoring(title: titleLabel.text!, lastScored: lastScoredLabel.text!, desc: descriptionLabel.text!, avg: avgLabel.text!, pr: perLabel.text!)
    }
    
}
