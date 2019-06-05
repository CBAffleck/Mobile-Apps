//
//  cancelScoring.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class cancelScoring: UIViewController {

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var cancelLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: Actions
    @IBAction func resumeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
    }
    
}
