//
//  signUpClass.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import QuartzCore

class signUpClass: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var schoolField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions
    @IBAction func signUp(_ sender: UIButton) {
    }
    
    @IBAction func backToSignIn(_ sender: UIButton) {
    }
    
}
