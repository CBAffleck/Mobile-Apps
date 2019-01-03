//
//  signUpClass.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import QuartzCore

class signUpClass: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    
    //MARK: Variables
    var userFirstName = ""
    var userLastName = ""
    var userSchool = ""
    var userEmail = ""
    var userPass = ""
    var userConfirmPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        // Handle the text field’s user input through delegate callbacks. Delegate is the viewcontroller
        firstNameField.delegate = self
        lastNameField.delegate = self
        schoolField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self

        //Text box color adjustment
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        schoolField.layer.borderWidth = 1
        schoolField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        confirmPasswordField.layer.borderWidth = 1
        confirmPasswordField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
    }
    
    //MARK: UITextDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    //Set placeholder text to red if what the user entered is invalid
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameField {
            if String(textField.text!) == "" {
                firstNameField.attributedPlaceholder = NSAttributedString(string: "FIRST NAME", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
            } else {
                userFirstName = String(textField.text!)
            }
        } else if textField == lastNameField {
            if String(textField.text!) == "" {
                lastNameField.attributedPlaceholder = NSAttributedString(string: "LAST NAME", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
            } else {
                userLastName = String(textField.text!)
            }
        } else if textField == schoolField {
            if String(textField.text!) == "" {
                schoolField.attributedPlaceholder = NSAttributedString(string: "SCHOOL", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
            } else {
                userSchool = String(textField.text!)
            }
        } else if textField == emailField {
            if String(textField.text!) == "" {
                emailField.attributedPlaceholder = NSAttributedString(string: "EMAIL", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
            } else {
                userEmail = String(textField.text!)
            }
        } else if textField == passwordField {
            if String(textField.text!) == "" {
                passwordField.attributedPlaceholder = NSAttributedString(string: "PASSWORD", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
            } else {
                userPass = String(textField.text!)
            }
        } else if textField == confirmPasswordField {
            if userPass != String(textField.text!) {
                confirmPasswordField.text = ""
                confirmPasswordField.attributedPlaceholder = NSAttributedString(string: "CONFIRM PASSWORD", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
            } else {
                userConfirmPass = String(textField.text!)
            }
        }
        //Disables the sign up button if the text fields aren't all filled out
        signUpButton.isEnabled = true
        [firstNameField, lastNameField, schoolField, emailField, passwordField, confirmPasswordField].forEach{
            if Bool(($0?.text?.isEmpty)!) {
                signUpButton.isEnabled = false
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
    }
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
}
