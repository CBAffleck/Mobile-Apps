//
//  MeetingInfoView.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import MapKit

class MeetingInfoView: MKAnnotationView {

    //MARK: Properties
    @IBOutlet weak var meetingTimeLabel: UILabel!
    @IBOutlet weak var meetinNotesView: UITextView!
    
    func configure(meetingTime : String, meetingNotes : String) {
        meetingTimeLabel.text = meetingTime
        meetinNotesView.text = meetingNotes
    }

}
