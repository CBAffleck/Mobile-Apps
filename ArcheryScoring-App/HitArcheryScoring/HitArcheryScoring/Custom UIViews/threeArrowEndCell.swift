//
//  threeArrowEndCell.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

protocol CellDelegate: NSObjectProtocol {
    func textFieldShouldEndEditing(end: Int, arrow: Int, score: String, cell: threeArrowEndCell)
}

class threeArrowEndCell: UITableViewCell, KeyboardDelegate, UITextFieldDelegate {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none     //Rows aren't highlighted if clicked on
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
    var delegate: CellDelegate?
    
    //Configure aesthetics for each part of the custom cell
    func setUp() {
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
        
        //Set keyboard to be custom scoring keyboard for arrow textFields (height = the custom keyboard height)
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
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        let score = textField.text
        var arrow = 0
        let end = Int(endLabel.text ?? "0")! - 1
        if textField == arrow1Field {
            arrow = 0
        } else if textField == arrow2Field {
            arrow = 1
        } else {
            arrow = 2
        }
        //Send data from textfield to the textScoring view controller using the protocol/delegate thing
        delegate?.textFieldShouldEndEditing(end: end, arrow: arrow, score: score ?? "0", cell: self)
        return true
    }
    
    //Fill in textfield with whichever key is pressed, and move on to the next textfield. Close keyboard after last field in row is edited.
    func keyWasTapped(character: String) {
        activeTextField.text = character
        if activeTextField == arrow1Field {
            activeTextField.resignFirstResponder()
            arrow2Field.becomeFirstResponder()
        } else if activeTextField == arrow2Field {
            activeTextField.resignFirstResponder()
            arrow3Field.becomeFirstResponder()
        } else {
            activeTextField.resignFirstResponder()
        }
    }
    
    //MARK: Actions
    @IBAction func enterArrow1(_ sender: UITextField) {
    }
    
    @IBAction func enterArrow2(_ sender: UITextField) {
    }
    
    @IBAction func enterArrow3(_ sender: UITextField) {
    }
    
}
