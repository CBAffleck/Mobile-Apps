//
//  threeArrowEndCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class threeArrowEndCell: UITableViewCell, KeyboardDelegate, UITextFieldDelegate {

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
    var activeTextField = UITextField()
    
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
        
        let keyboardView = keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
        keyboardView.delegate = self
        arrow1Field.delegate = self
        arrow2Field.delegate = self
        arrow3Field.delegate = self
        arrow1Field.inputView = keyboardView
        arrow2Field.inputView = keyboardView
        arrow3Field.inputView = keyboardView
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    
    func keyWasTapped(character: String) {
        activeTextField.insertText(character)
    }
    
    //MARK: Actions
    @IBAction func enterArrow1(_ sender: UITextField) {
    }
    
    @IBAction func enterArrow2(_ sender: UITextField) {
    }
    
    @IBAction func enterArrow3(_ sender: UITextField) {
    }
    
}
