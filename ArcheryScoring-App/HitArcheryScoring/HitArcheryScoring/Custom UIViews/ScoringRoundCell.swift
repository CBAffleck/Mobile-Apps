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

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastScoredLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var avgLabel: UILabel!
    @IBOutlet weak var perLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    //MARK: Variables
    var delegate: ScoringCellDelegate?
    var roundItem: ScoringRound!
    
    func setUpView() {
        addSubview(cellView)
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10)
        ])
    }
    
    func setInfo(round: ScoringRound) {
        roundItem = round
        titleLabel.text = round.title
        lastScoredLabel.text = round.lastScored
        descriptionLabel.text = round.description
        avgLabel.text = round.average
        perLabel.text = round.best
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 0.5
        cellView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
    }
    
    @IBAction func toScoringTapped(_ sender: UIButton) {
        delegate?.didTapToScoring(title: titleLabel.text!, lastScored: lastScoredLabel.text!, desc: descriptionLabel.text!, avg: avgLabel.text!, pr: perLabel.text!)
    }
    
}
