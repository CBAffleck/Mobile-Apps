//
//  meetingPopUp.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/6/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class meetingPopUp: UIViewController {

    //MARK: Properties
    @IBOutlet weak var meetingTimeLabel: UILabel!
    @IBOutlet weak var meetingNotesView: UITextView!
    @IBOutlet weak var closeButton: UIButton!
    
    //MARK: Variables
    var userTime = "None"
    var userNotes = "None"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        meetingTimeLabel.text = userTime
        meetingNotesView.text = userNotes
        // Do any additional setup after loading the view.
    }

    @IBAction func closePopUp(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
