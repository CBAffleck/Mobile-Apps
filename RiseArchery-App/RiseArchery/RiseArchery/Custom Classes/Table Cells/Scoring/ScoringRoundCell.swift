//
//  ScoringRoundCell.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

protocol ScoringCellDelegate {
    func didTapToScoring(row : Int)
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
    @IBOutlet weak var targetButton: UIButton!
    
    //MARK: Variables
    var delegate: ScoringCellDelegate?
    var roundItem: ScoringRound!
    
    func setInfo(round: ScoringRound) {
        roundItem             = round
        titleLabel.text       = round.roundName
        lastScoredLabel.text  = "Last Scored: " + round.lastScored
        descriptionLabel.text = round.roundDescription
        avgLabel.text         = "Average: " + String(round.average)
        perLabel.text         = "Personal Record: " + String(round.pr)
        
//        cellView.layer.shadowColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.2).cgColor
//        cellView.layer.shadowRadius = 6.0
//        cellView.layer.shadowOpacity = 0.5
//        cellView.layer.shadowOffset = CGSize(width: 4, height: 4)
        
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 0.75
        cellView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        targetButton.setImage(UIImage(named: round.targetFace + "Icon"), for: .normal)
        targetButton.adjustsImageWhenHighlighted = false
    }
    
    @IBAction func targetTapped(_ sender: UIButton) {
        delegate?.didTapToScoring(row : sender.tag)
    }
}
