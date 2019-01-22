//
//  newPassScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/22/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class NewPassScreen: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    
    //MARK: Variables
    var userEmail = ""
    var userPass = ""
    var userConfirmPass = ""
    var confirmCode = ""
    
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
//        emailField.delegate = self
        
        //Disable sign in button until all fields are properly filled in
//        sendButton.isEnabled = false
    }
    
    //MARK: AWS
    func makeNewPassword() {
        AWSMobileClient.sharedInstance().confirmForgotPassword(username: userEmail, newPassword: userPass, confirmationCode: confirmCode) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .done:
                    print("Password changed successfully")
                default:
                    print("Error: Could not change password.")
                }
            } else if let error = error {
                print("Error occurred: \(error.localizedDescription)")
            }
        }
    }
    
    //MARK: Keyboard Controls
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        userEmail = String(textField.text!)
        
        //Make placeholder text red if box is empty/entry is invalid
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
        }
        
        //Enable the sign up button if all text fields are filled out
//        sendButton.isEnabled = true
//        if (emailField.text?.isEmpty)! {
//            sendButton.isEnabled = false
//        }
    }
    
    //MARK: Actions
    
}
