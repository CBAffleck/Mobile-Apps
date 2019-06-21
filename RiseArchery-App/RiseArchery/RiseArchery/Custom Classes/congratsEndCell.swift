//
//  congratsEndCell.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class congratsEndCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var ar1Label: UILabel!
    @IBOutlet weak var ar2Label: UILabel!
    @IBOutlet weak var ar3Label: UILabel!
    @IBOutlet weak var totLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    //MARK: Functions
    func setInfo(end : ScoringEndData) {
        ar1Label.text = end.a1Score
        ar2Label.text = end.a2Score
        ar3Label.text = end.a3Score
        totLabel.text = end.endTot
        runLabel.text = end.runNum
        setArrowColors(labels: [ar1Label, ar2Label, ar3Label])
    }

    func setArrowColors(labels : [UILabel]) {
        for label in labels {
            if ["M", "0", "1", "2"].contains(label.text) {
                label.backgroundColor = UIColor.white
            } else if ["3", "4"].contains(label.text) {
                label.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
            } else if ["5", "6"].contains(label.text) {
                label.backgroundColor = UIColor(red: 171/255, green: 194/255, blue: 255/255, alpha: 1.0)
            } else if ["7", "8"].contains(label.text) {
                label.backgroundColor = UIColor(red: 255/255, green: 171/255, blue: 171/255, alpha: 1.0)
            } else if ["9", "10", "X"].contains(label.text) {
                label.backgroundColor = UIColor(red: 255/255, green: 252/255, blue: 171/255, alpha: 1.0)
            }
        }
    }
}
