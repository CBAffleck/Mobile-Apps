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
    
    //MARK: Properties
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var arrow1Field: UITextField!
    @IBOutlet weak var arrow2Field: UITextField!
    @IBOutlet weak var arrow3Field: UITextField!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    //MARK: Variables
    var activeTextField = UITextField()
    var delegate: CellDelegate?
    var edit = false
    var inputType = ""
    
    //Configure aesthetics for each part of the custom cell
    func setUp() {
        //Corner radius for row
        endLabel.layer.cornerRadius = 10
        arrow1Field.layer.cornerRadius = 10
        arrow2Field.layer.cornerRadius = 10
        arrow3Field.layer.cornerRadius = 10
        totalLabel.layer.cornerRadius = 10
        
        //Set corner radius
        endLabel.layer.masksToBounds = true
        arrow1Field.layer.masksToBounds = true
        arrow2Field.layer.masksToBounds = true
        arrow3Field.layer.masksToBounds = true
        totalLabel.layer.masksToBounds = true
        
        //Set keyboard to be custom scoring keyboard for arrow textFields (height = the custom keyboard height)
        if inputType == "text" {
            let keyboardView = keyboard(frame: CGRect(x: 0, y: 0, width: 0, height: 216))
            keyboardView.delegate = self
            arrow1Field.delegate = self
            arrow2Field.delegate = self
            arrow3Field.delegate = self
            arrow1Field.inputView = keyboardView
            arrow2Field.inputView = keyboardView
            arrow3Field.inputView = keyboardView
        } else {
            arrow1Field.isUserInteractionEnabled = false
            arrow2Field.isUserInteractionEnabled = false
            arrow3Field.isUserInteractionEnabled = false
        }
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        //If a field is being edited, set the edit bool to true and clear the field
        if !(textField.text?.isEmpty)! {
            textField.text = ""
            edit = true
        }
        //Make sure colors correspond to a scoring cell in which the user hasn't finished scoring yet
        cellView.backgroundColor = UIColor.white
        endLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        totalLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
        //Set textfield border when selected
        activeTextField.layer.borderWidth = 2.0
        activeTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
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
        let arrows = [arrow1Field.text, arrow2Field.text, arrow3Field.text]
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
    
}
