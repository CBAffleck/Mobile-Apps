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
    @IBOutlet weak var emailTakenNotice: UILabel!
    
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
        self.hideKeyboardOnTap()
        
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
        
        //Hide notice unless an email is entered that already has an account associated with it
        emailTakenNotice.isHidden = true
        
        //Populate text fields with data user entered when back button on verifyEmailScreen is clicked
        if !userFirstName.isEmpty {
            firstNameField.text = userFirstName
        }
        if !userLastName.isEmpty {
            lastNameField.text = userLastName
        }
        if !userEmail.isEmpty {
            emailField.text = userEmail
        }
        if !userPhone.isEmpty {
            phoneNumberField.text = userPhone
        }
        if !userSchool.isEmpty {
            schoolField.text = userSchool
        }
    }
    
    //MARK: AWS
    func signUpUser(errored: @escaping (Bool) -> Void) {
        AWSMobileClient.sharedInstance().signUp(
            username: userEmail,
            password: userConfirmPass,
            userAttributes: ["email":userEmail, "given_name": userFirstName, "family_name":userLastName, "zoneinfo":userSchool, "phone_number":userPhone]) { (signUpResult, error) in
                if let signUpResult = signUpResult {
                    switch(signUpResult.signUpConfirmationState) {
                    case .confirmed:
                        print("User is signed up and confirmed.")
                    case .unconfirmed:
                        print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "ToVerifyScreen", sender: self)
                        }
                    case .unknown:
                        print("Unexpected case")
                    }
                } else if let error = error {
                    if let error = error as? AWSMobileClientError {
                        switch(error) {
                        case .usernameExists(let message):
                            print(message)
                            errored(true)
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
            var typedPhone = String(textField.text!)
            typedPhone = typedPhone.replacingOccurrences(of: "+", with: "")
            typedPhone = typedPhone.replacingOccurrences(of: ",", with: "")
            typedPhone = typedPhone.replacingOccurrences(of: ";", with: "")
            typedPhone = typedPhone.replacingOccurrences(of: "#", with: "")
            typedPhone = typedPhone.replacingOccurrences(of: "*", with: "")
            if typedPhone.count < 10 {
                phoneNumberField.text = ""
            } else if typedPhone.prefix(2) != "+" && typedPhone.count == 11 {
                typedPhone = "+" + typedPhone.prefix(11)
            } else if typedPhone.prefix(2) != "+" {
                typedPhone = "+1" + typedPhone.prefix(10)
            }
            print(typedPhone)
            userPhone = typedPhone
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
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is VerifyEmailScreen {
            let view = segue.destination as? VerifyEmailScreen
            view?.userEmail = userEmail
            view?.userFirstName = userFirstName
            view?.userLastName = userLastName
            view?.userPhone = userPhone
            view?.userSchool = userSchool
        }
    }
    
    //MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
        let ifErrored: (Bool) -> Void = {
            if $0 {
                DispatchQueue.main.async {
                    self.emailTakenNotice.isHidden = false
                }
            }
        }
        signUpUser(errored: ifErrored)
    }
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
    
}

