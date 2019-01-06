//
//  ViewController.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import QuartzCore
import AWSMobileClient

class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var appNameLabel: UILabel!
    @IBOutlet weak var passTextField: UITextField!
    
    //MARK: Variables
    var userEmail = ""
    var userPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Handle the text field’s user input through delegate callbacks. Delegate is the viewcontroller
        emailTextField.delegate = self
        passTextField.delegate = self
        
        //Text box color adjustments
        emailTextField.layer.borderWidth = 1
        emailTextField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        passTextField.layer.borderWidth = 1
        passTextField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        
        //AWS Authentication initialization
        initializeAWSMobileClient()
    }
    
    // Initializing the AWSMobileClient and take action based on current user state
    func initializeAWSMobileClient() {
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            //self.addUserStateListener() // Register for user state changes
            
            if let userState = userState {
                switch(userState){
                case .signedIn: // is Signed IN
                    print("Logged In")
                    print("Cognito Identity Id (authenticated): \(String(describing: AWSMobileClient.sharedInstance().identityId)))")
                case .signedOut: // is Signed OUT
                    print("Logged Out")
                case .signedOutUserPoolsTokenInvalid: // User Pools refresh token INVALID
                    print("User Pools refresh token is invalid or expired.")
                case .signedOutFederatedTokensInvalid: // Facebook or Google refresh token INVALID
                    print("Federated refresh token is invalid or expired.")
                default:
                    AWSMobileClient.sharedInstance().signOut()
                }
            } else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    //MARK: UITextDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == emailTextField {
            userEmail = String(textField.text!)
        } else if textField == passTextField {
            userPass = String(textField.text!)
        }
        print(userEmail + " " + userPass)
    }
    
    //MARK: Actions
    @IBAction func signIn(_ sender: UIButton) {
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
    }
    
    @IBAction func signUp(_ sender: UIButton) {
    }
    

}

