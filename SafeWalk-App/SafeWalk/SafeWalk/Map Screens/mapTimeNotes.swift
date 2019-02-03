//
//  mapTimeNotes.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/28/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import AWSAuthCore
import AWSMobileClient
import MapKit
import CoreLocation

class mapTimeNotes: UIViewController, UITextViewDelegate, UIPickerViewDelegate {

    //MARK: Properties
    @IBOutlet weak var setTimeNotesButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    
    //MARK: Variables
    var userNotes = ""
    var userDate = Date()
    var meetingPoint : CLLocationCoordinate2D? = nil
    private var datePicker : UIDatePicker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Datepicker set up
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(mapTimeNotes.dateChanged(datePicker:)), for: .valueChanged)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tap(gestureReconizer:)))
        dateLabel.addGestureRecognizer(tap)
        dateLabel.isUserInteractionEnabled = true
        datePicker?.frame = CGRect(x: 0, y: self.view.frame.height - 200, width: self.view.frame.width, height: 200)
        datePicker?.isHidden = true
        datePicker?.minimumDate = Date()
        datePicker?.maximumDate = Calendar.current.date(byAdding: .day, value: 1, to: Date())!
        let closeTap = UITapGestureRecognizer(target: self, action: #selector(viewTapped(gestureReconizer:)))
        view.addSubview(datePicker!)
        view.addGestureRecognizer(closeTap)

        //AWS Mobile Client initialization
        AWSMobileClient.sharedInstance().initialize { (userState, error) in
            if let userState = userState {
                print("UserState: \(userState.rawValue)")
            } else if let error = error {
                print("error: \(error.localizedDescription)")
            }
        }
        
        //Set textview delegate
        notesField.delegate = self
        notesField.text = "Add any meeting notes here..."
        notesField.textColor = UIColor.lightGray
    }
    
    //MARK: Datepicker
    //Open datepicker if date label is tapped
    @objc func tap(gestureReconizer: UITapGestureRecognizer) {
        datePicker?.isHidden = false
        setTimeNotesButton.isHidden = true
    }
    
    //Close date picker or keyboard when background is tapped
    @objc func viewTapped(gestureReconizer: UITapGestureRecognizer) {
        datePicker?.isHidden = true
        setTimeNotesButton.isHidden = false
        view.endEditing(true)
    }
    
    //Formatting for date label when the date in the date picker is changed
    @objc func dateChanged(datePicker : UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        dateFormatter.locale = Locale(identifier: "en_US")
        dateLabel.text = dateFormatter.string(from: datePicker.date)
        userDate = dateFormatter.date(from: dateLabel.text!)!
        view.endEditing(true)
    }
    
    //MARK: Textview formatting
    func textViewDidBeginEditing(_ textView: UITextView) {
        if notesField.textColor == UIColor.lightGray {
            notesField.text = nil
            notesField.textColor = UIColor.black
            
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if notesField.text.isEmpty {
            textView.text = "Add any meeting notes here..."
            textView.textColor = UIColor.lightGray
        } else {
            userNotes = notesField.text
        }
    }

    //MARK: Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
        // Configure the destination view controller only when the save button is pressed.
        if segue.destination is mapSetDestination {
            let view = segue.destination as? mapSetDestination
            view?.userDate = userDate
            if notesField.textColor == UIColor.lightGray {
                userNotes = "None"
            }
            view?.userNotes = userNotes
            view?.meetingPoint = meetingPoint
        }
    }
    
    //MARK: Actions
    @IBAction func setTimeNotes(_ sender: UIButton) {
    }
    
    @IBAction func backToMainMapScreen(_ sender: UIButton) {
    }
}
