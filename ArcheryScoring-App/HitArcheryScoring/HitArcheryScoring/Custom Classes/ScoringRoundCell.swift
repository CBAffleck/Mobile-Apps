//
//  ScoringRoundCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

protocol ScoringCellDelegate {
    func didTapToScoring()
}

class ScoringRoundCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastScoredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var perLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    //MARK: Variables
    var delegate: ScoringCellDelegate?
    var roundItem: ScoringRoundTemp!
    
    func setInfo(round: ScoringRoundTemp) {
        roundItem = round
        titleLabel.text = round.title
        lastScoredLabel.text = round.lastScored
        descriptionLabel.text = round.description
        avgLabel.text = round.average
        perLabel.text = round.best
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 0.75
        cellView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
    }
    
    @IBAction func toScoringTapped(_ sender: UIButton) {
        delegate?.didTapToScoring()
    }
    
}
