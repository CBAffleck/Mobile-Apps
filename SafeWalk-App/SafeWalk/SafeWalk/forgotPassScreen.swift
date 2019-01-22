//
//  forgotPassScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class ForgotPassScreen: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: Variables
    var userEmail = ""
    
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
        emailField.delegate = self
        
        //Disable sign in button until all fields are properly filled in
        sendButton.isEnabled = false
    }
    
    //MARK: AWS
    func resetPassword() {
        AWSMobileClient.sharedInstance().forgotPassword(username: userEmail) { (forgotPasswordResult, error) in
            if let forgotPasswordResult = forgotPasswordResult {
                switch(forgotPasswordResult.forgotPasswordState) {
                case .confirmationCodeSent:
                    print("Confirmation code sent via \(forgotPasswordResult.codeDeliveryDetails!.deliveryMedium) to: \(forgotPasswordResult.codeDeliveryDetails!.destination!)")
                default:
                    print("Error: Invalid case.")
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
        sendButton.isEnabled = true
        if (emailField.text?.isEmpty)! {
            sendButton.isEnabled = false
        }
    }
    
    //MARK: Actions
    @IBAction func sendResetCode(_ sender: UIButton) {
        resetPassword()
    }
    
    @IBAction func goToSignIn(_ sender: UIButton) {
    }
    
}
