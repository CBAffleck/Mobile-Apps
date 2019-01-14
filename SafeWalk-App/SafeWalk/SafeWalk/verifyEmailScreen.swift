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
    func confirmUser() {
        AWSMobileClient.sharedInstance().confirmSignUp(username: userEmail, confirmationCode: String(verificationField.text!)) { (signUpResult, error) in
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
                print("\(error.localizedDescription)")
            }
        }
    }
    
    
    //MARK: Actions
    @IBAction func verifyEmail(_ sender: UIButton) {
        confirmUser()
    }
    
    @IBAction func backToSignUp(_ sender: UIButton) {
    }
    
    
}

