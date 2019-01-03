//
//  ViewController.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import QuartzCore

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var passTextField: UITextField!
    
    //MARK: Variables
    var userEmail = ""
    var userPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Handle the text field’s user input through delegate callbacks. Delegate is the viewcontroller
        emailTextField.delegate = self
        passTextField.delegate = self
        
        //Text box color adjustment
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        passTextField.layer.borderWidth = 1
        passTextField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
    }
    
    //MARK: UITextDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            userEmail = String(textField.text!)
        } else if textField == passTextField {
            userPass = String(textField.text!)
        }
        print(userEmail + " " + userPass)
    }
    
    //MARK: Actions
    @IBAction func signIn(_ sender: UIButton) {
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
    }
    
    @IBAction func signUp(_ sender: UIButton) {
    }
    

}

