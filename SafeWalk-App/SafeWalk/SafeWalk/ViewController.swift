//
//  ViewController.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var goToSignUpButton: UIButton!
    @IBOutlet weak var forgotPassButton: UIButton!
    @IBOutlet weak var incorrectEntryNotice: UILabel!
    
    //MARK: Variables
    var userEmail = ""
    var userPass = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AWS Mobile Client initialization
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
                switch(userState){
                    case .signedIn:
                        DispatchQueue.main.async {
                            self.performSegue(withIdentifier: "SignOutScreen", sender: self)
                        }
                    default:
                        AWSMobileClient.sharedInstance().signOut()
                }
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        //Set text field delegates
        emailField.delegate = self
        passwordField.delegate = self
        
        //Disable sign in button until all fields are properly filled in
        signInButton.isEnabled = false
        
        //Hide notice unless an incorrect email/password combination is entered
        incorrectEntryNotice.isHidden = true
    }
    
    //MARK: AWS
    func signInUser(errored: @escaping (Bool) -> Void) {
        AWSMobileClient.sharedInstance().signIn(username:String(emailField.text!), password:String(passwordField.text!)) { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
                errored(true)
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "SignOutScreen", sender: self)
                    }
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }

    //MARK: Keyboard Controls
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailField {
            textField.resignFirstResponder()
            passwordField.becomeFirstResponder()
        } else if textField == passwordField {
            textField.resignFirstResponder()
        }
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailField {
            userEmail = String(textField.text!)
        } else if textField == passwordField {
            userPass = String(textField.text!)
        }
        
        //Make placeholder text red if box is empty/entry is invalid
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
        }
        
        //Enable the sign up button if all text fields are filled out
        signInButton.isEnabled = true
        [emailField, passwordField].forEach{
            if Bool(($0?.text?.isEmpty)!) {
                signInButton.isEnabled = false
            }
        }
    }
    
    //MARK: Actions
    @IBAction func signInUser(_ sender: UIButton) {
        //If sign in fails, display incorrect email/pass label, empty password field, and change placeholder text to red
        let ifErrored: (Bool) -> Void = {
            if $0 {
                DispatchQueue.main.async {
                    self.passwordField.text = ""
                    self.passwordField.attributedPlaceholder = NSAttributedString(string: self.passwordField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
                    self.incorrectEntryNotice.isHidden = false
                }
            }
        }
        signInUser(errored: ifErrored)
    }
    
    @IBAction func goToSignUpScreen(_ sender: UIButton) {
    }
    
    @IBAction func goToResetPassScreen(_ sender: UIButton) {
    }
    
}

