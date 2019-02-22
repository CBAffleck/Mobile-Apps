//
//  verifyEmailScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class VerifyEmailScreen: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var verificationField: UITextField!
    @IBOutlet weak var verifyEmailButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    
    //MARK: Variables
    var userEmail = ""
    var userCode = ""
    //Other variables passed from signUp screen
    var userFirstName = ""
    var userLastName = ""
    var userPhone = ""
    var userSchool = ""
    
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
        verificationField.delegate = self
        
        //Disable sign in button until all fields are properly filled in
        verifyEmailButton.isEnabled = false
    }
    
    //MARK: AWS
    func confirmUser() {
        AWSMobileClient.sharedInstance().confirmSignUp(username: userEmail, confirmationCode: String(verificationField.text!)) { (signUpResult, error) in
            if let signUpResult = signUpResult {
                switch(signUpResult.signUpConfirmationState) {
                case .confirmed:
                    print("User is signed up and confirmed.")
                    DispatchQueue.main.async {
                        self.performSegue(withIdentifier: "ToEditProfileScreen", sender: self)
                    }
                case .unconfirmed:
                    print("User is not confirmed and needs verification via \(signUpResult.codeDeliveryDetails!.deliveryMedium) sent at \(signUpResult.codeDeliveryDetails!.destination!)")
                case .unknown:
                    print("Unexpected case")
                }
            } else if let error = error {
                print("\(error.localizedDescription)")
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
        userCode = String(textField.text!)
        
        //Make placeholder text red if box is empty/entry is invalid
        if textField.text == "" {
            textField.attributedPlaceholder = NSAttributedString(string: textField.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 255/255.00, green: 139/255.00, blue: 139/255.00, alpha: 1.0)])
        }
        
        //Enable the sign up button if all text fields are filled out
        verifyEmailButton.isEnabled = true
        if (verificationField.text?.isEmpty)! {
            verifyEmailButton.isEnabled = false
        }
    }
    
    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is SignUpScreen {
            let view = segue.destination as? SignUpScreen
            view?.userEmail = userEmail
            view?.userFirstName = userFirstName
            view?.userLastName = userLastName
            view?.userPhone = userPhone
            view?.userSchool = userSchool
        } else if segue.destination is editProfileScreen {
            let view = segue.destination as? editProfileScreen
            view?.firstName = userFirstName
            view?.lastName = userLastName
            view?.school = userSchool
        }
    }
    
    //MARK: Actions
    @IBAction func verifyEmail(_ sender: UIButton) {
        confirmUser()
    }
    
    @IBAction func backToSignUp(_ sender: UIButton) {
    }
    
    
}

