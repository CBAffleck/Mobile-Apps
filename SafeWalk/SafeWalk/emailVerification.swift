//
//  emailVerification.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class emailVerification: UIViewController, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var verificationField: UITextField!
    
    //MARK: Variables
    var userVerification = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        verificationField.delegate = self
        
        //Text box color adjustment
        verificationField.layer.borderWidth = 1
        verificationField.layer.borderColor = UIColor.init(red: 210/255.00, green: 210/255.00, blue: 210/255.00, alpha: 1.0).cgColor
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
        }
    }
    
    //MARK: Actions
    @IBAction func verifyEmail(_ sender: UIButton) {
    }
    
    @IBAction func backButton(_ sender: UIButton) {
    }
    
}
