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
    }
    
    //MARK: AWS
    func signInUser() {
        AWSMobileClient.sharedInstance().signIn(username:String(emailField.text!), password:String(passwordField.text!)) { (signInResult, error) in
            if let error = error  {
                print("\(error.localizedDescription)")
            } else if let signInResult = signInResult {
                switch (signInResult.signInState) {
                case .signedIn:
                    print("User is signed in.")
                case .smsMFA:
                    print("SMS message sent to \(signInResult.codeDetails!.destination!)")
                default:
                    print("Sign In needs info which is not yet supported.")
                }
            }
        }
    }

    //MARK: Actions
    @IBAction func signInUser(_ sender: UIButton) {
        signInUser()
    }
    
    @IBAction func goToSignUpScreen(_ sender: UIButton) {
    }
    

}

