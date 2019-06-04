//
//  threeArrowEndCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class threeArrowEndCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }

//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
    //MARK: Properties
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var arrow1Field: UITextField!
    @IBOutlet weak var arrow2Field: UITextField!
    @IBOutlet weak var arrow3Field: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    
    
    //MARK: Variables
    
    
    func setUp() {
//        cellView.layer.cornerRadius = 20
//        cellView.layer.borderWidth = 0.75
//        cellView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        
        //Corner radius for row
        endLabel.layer.cornerRadius = 10
        arrow1Field.layer.cornerRadius = 10
        arrow2Field.layer.cornerRadius = 10
        arrow3Field.layer.cornerRadius = 10
        totalLabel.layer.cornerRadius = 10
        runningLabel.layer.cornerRadius = 10
        
        //Set corner radius
        endLabel.layer.masksToBounds = true
        arrow1Field.layer.masksToBounds = true
        arrow2Field.layer.masksToBounds = true
        arrow3Field.layer.masksToBounds = true
        totalLabel.layer.masksToBounds = true
        runningLabel.layer.masksToBounds = true
    }
    
    //MARK: Actions
    @IBAction func enterArrow1(_ sender: UITextField) {
    }
    
    @IBAction func enterArrow2(_ sender: UITextField) {
    }
    
    @IBAction func enterArrow3(_ sender: UITextField) {
    }
    
}
