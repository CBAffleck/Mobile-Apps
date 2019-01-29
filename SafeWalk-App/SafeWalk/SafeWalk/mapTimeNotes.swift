//
//  mapTimeNotes.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 1/28/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class mapTimeNotes: UIViewController {

    //MARK: Properties
    @IBOutlet weak var setTimeNotesButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var notesField: UITextView!
    
    //MARK: Variables
    
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
    @IBAction func setTimeNotes(_ sender: UIButton) {
    }
    
    @IBAction func backToMainMapScreen(_ sender: UIButton) {
    }
}
