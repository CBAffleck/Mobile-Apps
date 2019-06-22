//
//  cancelScoring.swift
//  RiseArchery
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
    var imgCount = 0
    var scoringType = "text"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        
        if scoringType == "practice" {
            descLabel.text = "If you cancel this practice round you’ll lose all progress. Are you sure you want to cancel?"
            cancelLabel.text = "Cancel Practice?"
            cancelButton.setTitle("Cancel Practice", for: .normal)
        }
    }
    
    //MARK: Functions
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: Actions
    @IBAction func resumeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "dismissDimView"), object: nil)
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.modalTransitionStyle = .crossDissolve
            self.view.alpha = 0
        }, completion: nil)
        dismiss(animated: true)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        if (scoringType == "target" || scoringType == "practice") && imgCount > 1 {
            for i in 1...imgCount - 1 {
                removeImage(imageName: "temp" + String(i))
            }
        }
    }
    
}
