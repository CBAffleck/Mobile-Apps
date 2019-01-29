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

class mapTimeNotes: UIViewController, UITextViewDelegate {

    //MARK: Properties
    @IBOutlet weak var setTimeNotesButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    
    //MARK: Variables
    var userNotes = ""
    var userDate = ""
    var userTime = ""
    var meetingPoint : CLLocationCoordinate2D? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardOnTap()

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
    
    //Handle textview stuff
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
            view?.userTime = userTime
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
