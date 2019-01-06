//
//  emailVerification.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSMobileClient

class emailVerification: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var verificationField: UITextField!
    @IBOutlet weak var verifyEmailButton: UIButton!
    
    //MARK: Variables
    var userVerification = ""
    var email = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        verificationField.delegate = self
        verifyEmailButton.isEnabled = false
        
        
        //Text box color adjustment
        verificationField.layer.borderWidth = 1
        verificationField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
    }
    
    func verifyUser() {
        AWSMobileClient.sharedInstance().confirmSignUp(username: email, confirmationCode: userVerification) { (signUpResult, error) in
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: UITextDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //When the textfield being edited is ready to be read, set the corresponding variable's text to the user input
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == verificationField {
            userVerification = String(textField.text!)
            verifyEmailButton.isEnabled = true
        }
    }
    
    //MARK: Actions
    @IBAction func verifyEmail(_ sender: UIButton) {
        verifyUser()
    }
    
    @IBAction func backButton(_ sender: UIButton) {
    }
    
}
