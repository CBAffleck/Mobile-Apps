//
//  editProfile.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/14/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class editProfile: UIViewController, UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImagePickerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var choosePicButton: UIButton!
    @IBOutlet weak var removePicButton: UIButton!
    @IBOutlet weak var firstNameField: UITextField!
    @IBOutlet weak var lastNameField: UITextField!
    @IBOutlet weak var shootingStyleField: UITextField!
    @IBOutlet weak var pr18Field: UITextField!
    @IBOutlet weak var pr50Field: UITextField!
    @IBOutlet weak var pr70Field: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    //MARK: Variables
    let realm = try! Realm()
    var currUser = UserInfo()
    var activeTextField = UITextField()
    var pickedImage: UIImage!
    var imagePicker: ImagePicker!
    var round18: ScoringRound!
    var round50: ScoringRound!
    var round70: ScoringRound!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        getRounds()
        pickedImage = loadImageFromDiskWith(fileName: currUser.profilePic)

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 20
        scrollView.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
        
        //Button formatting
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        choosePicButton.layer.cornerRadius = 10
        removePicButton.layer.cornerRadius = 10
        saveButton.layer.cornerRadius = 10
        
        //Corner radius for textfields
        firstNameField.layer.cornerRadius = 10
        lastNameField.layer.cornerRadius = 10
        shootingStyleField.layer.cornerRadius = 10
        pr18Field.layer.cornerRadius = 10
        pr50Field.layer.cornerRadius = 10
        pr70Field.layer.cornerRadius = 10
        
        //Set textfield corner radius
        firstNameField.layer.masksToBounds = true
        lastNameField.layer.masksToBounds = true
        shootingStyleField.layer.masksToBounds = true
        pr18Field.layer.masksToBounds = true
        pr50Field.layer.masksToBounds = true
        pr70Field.layer.masksToBounds = true
        
        //Set delegates
        firstNameField.delegate = self
        lastNameField.delegate = self
        shootingStyleField.delegate = self
        pr18Field.delegate = self
        pr50Field.delegate = self
        pr70Field.delegate = self
        
        //Set textfields
        firstNameField.text = currUser.firstName
        lastNameField.text = currUser.lastName
        shootingStyleField.text = currUser.bowType
        if !(currUser.pr18 == 0) { pr18Field.text = String(currUser.pr18) }
        if !(currUser.pr50 == 0) { pr50Field.text = String(currUser.pr50) }
        if !(currUser.pr70 == 0) { pr70Field.text = String(currUser.pr70) }
        
    }
    
    func getRounds() {
        for round in realm.objects(ScoringRound.self) {
            if round.distance == "18m" { round18 = round }
            else if round.distance == "50m" { round50 = round }
            else if round.distance == "70m" { round70 = round }
        }
    }
    
    //MARK: Textfield Functions
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
        //Set textfield border when selected
        activeTextField.layer.borderWidth = 2.0
        activeTextField.layer.borderColor = UIColor.black.cgColor
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        //When a field is done being edited, remove the border and update the end total
        activeTextField.layer.borderWidth = 0.0
    }
    
    //MARK: Keyboard Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
            let contentInset : UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardHeight - 100, right: 0)
            scrollView.contentInset = contentInset
        }
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        scrollView.contentInset = UIEdgeInsets.zero
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Photo functions
    func didSelect(image: UIImage?) {
        self.pickedImage = image
        saveProfilePic()
    }
    
    func saveUserInfo() {
        let pr18 = Int(pr18Field.text ?? "0") ?? 0
        let pr50 = Int(pr50Field.text ?? "0") ?? 0
        let pr70 = Int(pr70Field.text ?? "0") ?? 0
        try! realm.write {
            currUser.firstName = firstNameField.text ?? "First"
            currUser.lastName = lastNameField.text ?? "Last"
            currUser.bowType = shootingStyleField.text ?? "Olympic Recurve"
            currUser.pr18 = pr18
            currUser.pr50 = pr50
            currUser.pr70 = pr70
            round18.pr = max(round18.pastScores.max() ?? 0, pr18)
            round50.pr = max(round50.pastScores.max() ?? 0, pr50)
            round70.pr = max(round70.pastScores.max() ?? 0, pr70)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
    func saveProfilePic() {
        saveImage(imageName: "ProfilePic", image: pickedImage ?? loadImageFromDiskWith(fileName: currUser.profilePic))
        try! realm.write {
            currUser.profilePic = "ProfilePic"
        }
    }
    
    func removeProfilePic() {
        try! realm.write {
            currUser.profilePic = "EditProfile"
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
    @IBAction func closeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.modalTransitionStyle = .crossDissolve
            self.view.alpha = 0
        }, completion: nil)
        dismiss(animated: true)
    }
    
    @IBAction func chooseTapped(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
    @IBAction func removeTapped(_ sender: UIButton) {
        removeProfilePic()
    }
    
    @IBAction func saveTapped(_ sender: UIButton) {
        saveUserInfo()
    }
    
    @IBAction func firstNameTapped(_ sender: ProfileEditFields) {
    }
    @IBAction func lastNameTapped(_ sender: ProfileEditFields) {
    }
    @IBAction func shootingTapped(_ sender: ProfileEditFields) {
    }
    @IBAction func pr18Tapped(_ sender: UITextField) {
    }
    @IBAction func pr50Tapped(_ sender: UITextField) {
    }
    @IBAction func pr70Tapped(_ sender: UITextField) {
    }
    
    
}

class ProfileEditFields : UITextField {
    
    let padding = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
