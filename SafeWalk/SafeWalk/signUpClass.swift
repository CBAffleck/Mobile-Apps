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
    
    //MARK: Variables
    var userFirstName = ""
    var userLastName = ""
    var userSchool = ""
    var userEmail = ""
    var userPass = ""
    var userConfirmPass = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        // Handle the text field’s user input through delegate callbacks. Delegate is the viewcontroller
        firstNameField.delegate = self
        lastNameField.delegate = self
        schoolField.delegate = self
        emailField.delegate = self
        passwordField.delegate = self
        confirmPasswordField.delegate = self
        
        //Text box color adjustment
        firstNameField.layer.borderWidth = 1
        firstNameField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        lastNameField.layer.borderWidth = 1
        lastNameField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        schoolField.layer.borderWidth = 1
        schoolField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        emailField.layer.borderWidth = 1
        emailField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        passwordField.layer.borderWidth = 1
        passwordField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
        confirmPasswordField.layer.borderWidth = 1
        confirmPasswordField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
    }
    
    //MARK: UITextDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == firstNameField {
            userFirstName = String(textField.text!)
        } else if textField == lastNameField {
            userLastName = String(textField.text!)
        } else if textField == schoolField {
            userSchool = String(textField.text!)
        } else if textField == emailField {
            userEmail = String(textField.text!)
        } else if textField == passwordField {
            userPass = String(textField.text!)
        } else if textField == confirmPasswordField {
            userConfirmPass = String(textField.text!)
        }
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
