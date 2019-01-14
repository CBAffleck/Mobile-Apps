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
    
    
    //MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
        signUpUser()
    }
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
    
}

