//
//  verifyPassScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/22/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class VerifyPassScreen: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var verificationCodeField: UITextField!
    @IBOutlet weak var verifyCodeButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //MARK: Variables
    var userCode = ""
    var userEmail = ""
    
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
        verificationCodeField.delegate = self
        
        //Disable sign in button until all fields are properly filled in
        verifyCodeButton.isEnabled = false
    }
    
    //MARK: Keyboard Controls
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        userCode = String(textField.text!)
        
        //Make placeholder text red if box is empty/entry is invalid
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
        }
        
        //Enable the sign up button if all text fields are filled out
        verifyCodeButton.isEnabled = true
        if (verificationCodeField.text?.isEmpty)! {
            verifyCodeButton.isEnabled = false
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is NewPassScreen {
            let view = segue.destination as? NewPassScreen
            view?.confirmCode = userCode
            view?.userEmail = userEmail
        }
    }
    
    //MARK: Actions
    @IBAction func toNewPassScreen(_ sender: UIButton) {
    }
    
    @IBAction func toForgotPassScreen(_ sender: UIButton) {
    }
    
}

