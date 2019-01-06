//
//  signUpClass.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import QuartzCore
import AWSMobileClient
import os.log

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
        [firstNameField, lastNameField, schoolField, emailField, passwordField, confirmPasswordField].forEach{
            $0?.layer.borderWidth = 1
            $0?.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        }
    }
    
    func signUpUser() {
        AWSMobileClient.sharedInstance().signUp(username: userEmail, password: userConfirmPass, userAttributes: ["email":userEmail, "given_name":userFirstName, "family_name": userLastName, "school":userSchool]) { (signUpResult, error) in
                if let signUpResult = signUpResult {
                    switch(signUpResult.signUpConfirmationState) {
                        case .confirmed:
                            print("User is signed up and confirmed.")
                        case .unconfirmed:
                            print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                        case .unknown:
                            print("Unexpected case")
                    }
                } else if let error = error {
                    if let error = error as? AWSMobileClientError {
                        switch(error) {
                            case .usernameExists(let message):
                                print(message)
                            default:
                                break
                        }
                    }
                    print("\(error.localizedDescription)")
                }
        }
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
            userFirstName = String(textField.text!)
        } else if textField == lastNameField {
            userLastName = String(textField.text!)
        } else if textField == schoolField {
            userSchool = String(textField.text!)
        } else if textField == emailField {
            userEmail = String(textField.text!)
        } else if textField == passwordField {
            userPass = String(textField.text!)
        } else if textField == confirmPasswordField {
            if userPass != String(textField.text!) {
                confirmPasswordField.text = ""
            } else {
                userConfirmPass = String(textField.text!)
            }
        }
        //Make placeholder text red if box is empty/entry is invalid
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
        }
        //Disables the sign up button if the text fields aren't all filled out
        signUpButton.isEnabled = true
        [firstNameField, lastNameField, schoolField, emailField, passwordField, confirmPasswordField].forEach{
            if Bool(($0?.text?.isEmpty)!) {
                signUpButton.isEnabled = false
            }
        }
    }

    //MARK: Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is emailVerification {
            let view = segue.destination as? emailVerification
            view?.email = userEmail
        }
    }
    
    //MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
        signUpUser()
    }
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
}
