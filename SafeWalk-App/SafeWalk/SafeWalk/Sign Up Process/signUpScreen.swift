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
    //Password Pop Up Variables
    var passUpper = false
    var passLower = false
    var passNum = false
    var passSpecial = false
    var passMin = false
    
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
            if !isCalEmail(email: textField.text ?? "none") {
                showEmailPopUp()
                return true
            }
            phoneNumberField.becomeFirstResponder()
        } else if textField == phoneNumberField {
            textField.resignFirstResponder()
            schoolField.becomeFirstResponder()
        } else if textField == schoolField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
            if isValidPassword(password: textField.text ?? "none") {
                confirmPassField.becomeFirstResponder()
            } else {
                passwordField.text = ""
                showPasswordPopUp()
                return true
            }
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
            if typedPhone.count < 10 {
                phoneNumberField.text = ""
            } else if typedPhone.count > 10 {
                typedPhone = String(typedPhone.prefix(10))
            }
            typedPhone = "+1" + typedPhone
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
    
    func showPasswordPopUp() {
        let popUpStoryboard = UIStoryboard(name: "passwordPopUp", bundle: nil)
        let popUp = popUpStoryboard.instantiateViewController(withIdentifier: "passPopUpID") as! passwordPopUp
        popUp.modalTransitionStyle = .crossDissolve
        popUp.upperCase = passUpper
        popUp.lowerCase = passLower
        popUp.number = passNum
        popUp.specialChar = passSpecial
        popUp.length = passMin
        self.present(popUp, animated: true, completion: nil)
    }
    
    func showEmailPopUp() {
        let popUpStoryboard = UIStoryboard(name: "emailPopUp", bundle: nil)
        let popUp = popUpStoryboard.instantiateViewController(withIdentifier: "emailPopUpID") as! emailPopUp
        popUp.modalTransitionStyle = .crossDissolve
        self.present(popUp, animated: true, completion: nil)
    }
    
    //Checks if entered password is valid, and sets bool value for each variable corresponding to the password requirements
    func isValidPassword(password : String) -> Bool {
        let regex = "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@$%*?&#]).{8,}$"
        passUpper = NSPredicate(format: "SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with:password)
        passLower = NSPredicate(format: "SELF MATCHES %@", ".*[a-z]+.*").evaluate(with:password)
        passNum = NSPredicate(format: "SELF MATCHES %@", ".*[0-9]+.*").evaluate(with:password)
        passSpecial = NSPredicate(format: "SELF MATCHES %@", ".*[!@$%*?&#]+.*").evaluate(with:password)
        passMin = NSPredicate(format: "SELF MATCHES %@", ".{8,}").evaluate(with:password)
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with:password)
    }
    
    //Checks if the email entered is a @berkeley.edu email address
    func isCalEmail(email : String) -> Bool {
        let host = String(email.suffix(13))
        print(host)
        if host == "@berkeley.edu" {
            return true
        }
        return false
    }
    
    //Show pop up if necessary when keyboard is dismissed by tapping background
    @objc override func dismissKeyboard() {
        view.endEditing(true)
        if passwordField.text != "" {
            if !isValidPassword(password: passwordField.text!) {
                passwordField.text = ""
                showPasswordPopUp()
            }
        } else if emailField.text != "" {
            if !isCalEmail(email: emailField.text!) {
                showEmailPopUp()
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

