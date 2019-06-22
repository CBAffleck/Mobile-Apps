//
//  practiceHistory.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class practiceHistory: UIViewController {

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arrowCountLabel: UILabel!
    @IBOutlet weak var targetImageView: UIImageView!
    
    //MARK: Variables
    var roundTitle: String = ""
    var time : String = ""
    var date : String = ""
    var arrowCount : Int = 0
    var targetFace : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTargetImage()
        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 20
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        
        titleLabel.text = roundTitle
        dateLabel.text = date
        timeLabel.text = "Time: " + time
        arrowCountLabel.text = "Arrow Count: " + String(arrowCount)
    }
    
    //MARK: Functions
    func addTargetImage() {
        print(roundTitle)
        print(targetFace)
        targetImageView.image = loadImageFromDiskWith(fileName: targetFace + String(roundTitle.prefix(3)) + String(roundTitle.components(separatedBy: "#")[1]) + "practice")
    }
    
    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseOut, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1, y: 1)
            self.modalTransitionStyle = .crossDissolve
            self.view.alpha = 0
        }, completion: nil)
        dismiss(animated: true)
    }
    

}
