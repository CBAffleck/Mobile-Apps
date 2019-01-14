//
//  signUpScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class SignUpScreen: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var phoneNumberField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPassField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: Variables
    var userFirstName = ""
    var userLastName = ""
    var userEmail = ""
    var userPhone = ""
    var userSchool = ""
    var userPass = ""
    var userConfirmPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AWS Mobile Client initialization
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        //Set text field delegates
        firstNameField.delegate = self
        lastNameField.delegate = self
        emailField.delegate = self
        phoneNumberField.delegate = self
        schoolField.delegate = self
        passwordField.delegate = self
        confirmPassField.delegate = self
        
        //Disable sign up button until all fields are properly filled in
        signUpButton.isEnabled = false
    }
    
    //MARK: AWS
    func signUpUser() {
        AWSMobileClient.sharedInstance().signUp(
            username: String(emailField.text!),
            password: String(passwordField.text!),
            userAttributes: ["email":String(emailField.text!), "given_name": String(firstNameField.text!), "family_name":String(lastNameField.text!), "zoneinfo":String(schoolField.text!), "phone_number":String(phoneNumberField.text!)]) { (signUpResult, error) in
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
    
    //MARK: Keyboard Controls
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == firstNameField {
            textField.resignFirstResponder()
            lastNameField.becomeFirstResponder()
        } else if textField == lastNameField {
            textField.resignFirstResponder()
            emailField.becomeFirstResponder()
        } else if textField == emailField {
            textField.resignFirstResponder()
            phoneNumberField.becomeFirstResponder()
        } else if textField == phoneNumberField {
            textField.resignFirstResponder()
            schoolField.becomeFirstResponder()
        } else if textField == schoolField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
            confirmPassField.becomeFirstResponder()
        } else if textField == confirmPassField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameField {
            userFirstName = String(textField.text!)
        } else if textField == lastNameField {
            userLastName = String(textField.text!)
        } else if textField == emailField {
            userEmail = String(textField.text!)
        } else if textField == phoneNumberField {
            userPhone = String(textField.text!)
        } else if textField == schoolField {
            userSchool = String(textField.text!)
        } else if textField == passwordField {
            userPass = String(textField.text!)
        } else if textField == confirmPassField {
            if userPass != String(textField.text!) {
                confirmPassField.text = ""
            } else {
                userConfirmPass = String(textField.text!)
            }
        }
        
        //Make placeholder text red if box is empty/entry is invalid
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
        }
        
        //Enable the sign up button if all text fields are filled out
        signUpButton.isEnabled = true
        [firstNameField, lastNameField, emailField, phoneNumberField, schoolField, passwordField, confirmPassField].forEach{
            if Bool(($0?.text?.isEmpty)!) {
                signUpButton.isEnabled = false
            }
        }
    }
    
    //MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
        signUpUser()
    }
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
    
}

