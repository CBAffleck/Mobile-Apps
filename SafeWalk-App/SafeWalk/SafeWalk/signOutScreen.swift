//
//  signOutScreen.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/13/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient

class SignOutScreen: UIViewController, UITextFieldDelegate {
    
    //MARK: Properties
    @IBOutlet weak var signOutButton: UIButton!
    
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
    func signOutUser() {
        AWSMobileClient.sharedInstance().signOut()
    }
    
    //MARK: Actions
    @IBAction func signOut(_ sender: UIButton) {
        signOutUser()
    }
    

}
