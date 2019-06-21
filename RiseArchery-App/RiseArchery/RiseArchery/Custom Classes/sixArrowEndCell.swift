//
//  sixArrowEndCell.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class sixArrowEndCell: UITableViewCell, KeyboardDelegate, UITextFieldDelegate {
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none     //Rows aren't highlighted if clicked on
    }

    //MARK: Properties
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var arrow1Field: UITextField!
    @IBOutlet weak var arrow2Field: UITextField!
    @IBOutlet weak var arrow3Field: UITextField!
    @IBOutlet weak var arrow4Field: UITextField!
    @IBOutlet weak var arrow5Field: UITextField!
    @IBOutlet weak var arrow6Field: UITextField!
    
    
    //MARK: Variables
    var activeTextField = UITextField()
    var delegate: CellDelegate?
    var edit = false
    var inputType = ""
    
    //MARK: Functions
    func setUp() {
        //Corner radius for row
        endLabel.layer.cornerRadius = 10
        arrow1Field.layer.cornerRadius = 10
        arrow2Field.layer.cornerRadius = 10
        arrow3Field.layer.cornerRadius = 10
        arrow4Field.layer.cornerRadius = 10
        arrow5Field.layer.cornerRadius = 10
        arrow6Field.layer.cornerRadius = 10
        totalLabel.layer.cornerRadius = 10
        
        //Set corner radius
        endLabel.layer.masksToBounds = true
        arrow1Field.layer.masksToBounds = true
        arrow2Field.layer.masksToBounds = true
        arrow3Field.layer.masksToBounds = true
        arrow4Field.layer.masksToBounds = true
        arrow5Field.layer.masksToBounds = true
        arrow6Field.layer.masksToBounds = true
        totalLabel.layer.masksToBounds = true
        
        //Set keyboard to be custom scoring keyboard for arrow textFields (height = the custom keyboard height)
        if inputType == "text" {
            let keyboardView = keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
            keyboardView.delegate = self
            arrow1Field.delegate = self
            arrow2Field.delegate = self
            arrow3Field.delegate = self
            arrow4Field.delegate = self
            arrow5Field.delegate = self
            arrow6Field.delegate = self
            arrow1Field.inputView = keyboardView
            arrow2Field.inputView = keyboardView
            arrow3Field.inputView = keyboardView
            arrow4Field.inputView = keyboardView
            arrow5Field.inputView = keyboardView
            arrow6Field.inputView = keyboardView
        } else {
            arrow1Field.isUserInteractionEnabled = false
            arrow2Field.isUserInteractionEnabled = false
            arrow3Field.isUserInteractionEnabled = false
            arrow4Field.isUserInteractionEnabled = false
            arrow5Field.isUserInteractionEnabled = false
            arrow6Field.isUserInteractionEnabled = false
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        //If a field is being edited, set the edit bool to true and clear the field
        if !(textField.text?.isEmpty)! {
            textField.text = ""
            edit = true
        }
        //Deal with telling keyboard to move up if it's the first or only cell being edited
        if textField == arrow1Field || edit == true { delegate?.textFieldBeganEditing(row: Int(endLabel.text ?? "0")!, showKB: true, hideKB: false) }
        else { delegate?.textFieldBeganEditing(row: Int(endLabel.text ?? "0")!, showKB: false, hideKB: false) }
        //Make sure colors correspond to a scoring cell in which the user hasn't finished scoring yet
        cellView.backgroundColor = UIColor.white
        endLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        totalLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        //Set textfield border when selected
        activeTextField.layer.borderWidth = 2.0
        activeTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        //Deal with dismissing keyboard if it's the last or only cell being edited
        if textField == arrow6Field  || edit == true { delegate?.textFieldBeganEditing(row: Int(endLabel.text ?? "0")!, showKB: false, hideKB: true) }
        //When a field is done being edited, remove the border and update the end total
        activeTextField.layer.borderWidth = 0.0
        totalLabel.text = String(calculateEndTotal())
        let score = textField.text
        var arrow = 0
        let end = Int(endLabel.text ?? "0")! - 1
        if textField == arrow1Field {
            arrow = 0
        } else if textField == arrow2Field {
            arrow = 1
        } else if textField == arrow3Field {
            arrow = 2
        } else if textField == arrow4Field {
            arrow = 3
        } else if textField == arrow5Field {
            arrow = 4
        } else if textField == arrow6Field {
            arrow = 5
        }
        //Send data from textfield to the textScoring view controller using the protocol/delegate thing
        delegate?.textFieldShouldEndEditing(end: end, arrow: arrow, score: score ?? "0")
        return true
    }
    
    func keyWasTapped(character: String) {
        activeTextField.text = character
        //Sets textfield background color in accordance with arrow score
        if ["M", "1", "2"].contains(character) {
            activeTextField.backgroundColor = UIColor.white
        } else if ["3", "4"].contains(character) {
            activeTextField.backgroundColor = UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
        } else if ["5", "6"].contains(character) {
            activeTextField.backgroundColor = UIColor(red: 171/255, green: 194/255, blue: 255/255, alpha: 1.0)
        } else if ["7", "8"].contains(character) {
            activeTextField.backgroundColor = UIColor(red: 255/255, green: 171/255, blue: 171/255, alpha: 1.0)
        } else if ["9", "10", "X"].contains(character) {
            activeTextField.backgroundColor = UIColor(red: 255/255, green: 252/255, blue: 171/255, alpha: 1.0)
        }
        //Move focus to next textfield, or close keyboard if leaving last textfield
        if activeTextField == arrow1Field {
            activeTextField.resignFirstResponder()
            //If a field was being edited, then we don't transition to a new field, and we reset the background color to match the colors of a complete row
            if edit == true {
                setColors()
            } else { arrow2Field.becomeFirstResponder() }
            edit = false
        } else if activeTextField == arrow2Field {
            activeTextField.resignFirstResponder()
            if edit == true {
                setColors()
            } else { arrow3Field.becomeFirstResponder() }
            edit = false
        }  else if activeTextField == arrow3Field {
            activeTextField.resignFirstResponder()
            if edit == true {
                setColors()
            } else { arrow4Field.becomeFirstResponder() }
            edit = false
        } else if activeTextField == arrow4Field {
            activeTextField.resignFirstResponder()
            if edit == true {
                setColors()
            } else { arrow5Field.becomeFirstResponder() }
            edit = false
        } else if activeTextField == arrow5Field {
            activeTextField.resignFirstResponder()
            if edit == true {
                setColors()
            } else { arrow6Field.becomeFirstResponder() }
            edit = false
        } else {
            activeTextField.resignFirstResponder()
            edit = false
            //Change colors of cell to indicate that the cell is complete
            setColors()
        }
    }
    
    //Sets cell, endlabel, and totallabel to the same green so their boxes disappear
    func setColors() {
        cellView.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
        endLabel.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
        totalLabel.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
    }
    
    func calculateEndTotal() -> Int {
        let arrows = [arrow1Field.text, arrow2Field.text, arrow3Field.text, arrow4Field.text, arrow5Field.text, arrow6Field.text]
        var total = 0
        for a in arrows {
            if a == "X" { total += 10}
            else if a == "M" { total += 0}
            else { total += Int(a!) ?? 0}
        }
        return total
    }
    
    
    //MARK: Actions
    @IBAction func enterArrow1(_ sender: UITextField) {
    }
    @IBAction func enterArrow2(_ sender: UITextField) {
    }
    @IBAction func enterArrow3(_ sender: UITextField) {
    }
    @IBAction func enterArrow4(_ sender: UITextField) {
    }
    @IBAction func enterArrow5(_ sender: UITextField) {
    }
    @IBAction func enterArrow6(_ sender: UITextField) {
    }
    
}
