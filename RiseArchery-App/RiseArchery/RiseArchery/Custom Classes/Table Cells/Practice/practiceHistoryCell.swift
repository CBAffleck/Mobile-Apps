//
//  practiceHistoryCell.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class practiceHistoryCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var targetIndicator: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var arrowCountLabel: UILabel!
    
    //MARK: Variables
    var historyItem : HistoryPracticeRound!
    var roundTitle: String?
    var time : String?
    var date : String?
    var arrowCount : Int?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

    func setInfo(round: HistoryPracticeRound) {
        //Set variables from Realm object
        historyItem = round
        self.roundTitle = round.roundName
        self.time = round.time
        self.date = round.date
        self.arrowCount = round.arrowScores.count
        
        //Set labels in cell
        dateLabel.text = date
        titleLabel.text = roundTitle
        arrowCountLabel.text = "Arrow Count: " + String(arrowCount!)
        
        //Setup cell layout details
        cellView.layer.cornerRadius = 20
        cellView.layer.borderWidth = 0.75
        cellView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        
        //Set up indicator icons
        targetIndicator.image = UIImage(named: round.targetFace + "Icon")
        targetIndicator.isHidden = false
        targetIndicator.alpha = 0.3
    }
}
