//
//  practiceCongrats.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import Lottie

class practiceCongrats: UIViewController {

    //MARK: Properties
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var congratsLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var animeView: AnimationView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var arrowCountLabel: UILabel!
    
    //MARK: Variables
    let animationView = AnimationView()
    var roundNum = 0                    //Round number in users history, pulled from realm
    var headerTitle = ""
    var time = ""
    var date = ""
    var targetImage = UIImage()
    var inArrows: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setDescLabel()
        
        //Set labels to match round data
        arrowCountLabel.text  = "Arrow Count: " + String(inArrows.count)
        detailTitleLabel.text = headerTitle
        timeLabel.text        = "Time: " + time
        dateLabel.text        = date
        
        //Add border to details view
        detailsView.layer.cornerRadius = 20
        detailsView.layer.borderWidth  = 0.75
        detailsView.layer.borderColor  = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        
        //Add corner radius to close button and make x smaller
        closeButton.imageEdgeInsets    = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        
        targetImageView.image          = targetImage
        
        let animation       = Animation.named("Trophy")
        animeView.animation = animation
        animeView.play()
    }
    
    //MARK: Functions
    func setDescLabel() {
        var nthNum = ""
        let digit = roundNum % 10
        if roundNum >= 4 && roundNum <= 20 {
            nthNum = "th "
        } else if digit == 1 {
            nthNum = "st "
        } else if digit == 2 {
            nthNum = "nd "
        } else if digit == 3 {
            nthNum = "rd "
        } else {
            nthNum = "th "
        }
        descLabel.text = "You completed your " + String(roundNum) + nthNum + headerTitle.prefix(4) + "round!"
    }
    
    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "reloadData"), object: nil)
    }
    
}
