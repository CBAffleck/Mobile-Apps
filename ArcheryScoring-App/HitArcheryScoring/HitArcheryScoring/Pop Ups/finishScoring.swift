//
//  finishScoring.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class finishScoring: UIViewController {

    //MARK: Properties
    @IBOutlet weak var finishView: UIView!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var resumeButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    
    //MARK: Variables
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        finishView.layer.cornerRadius = 20
        resumeButton.layer.cornerRadius = 10
        finishButton.layer.cornerRadius = 10
    }
    

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        super.prepare(for: segue, sender: sender)
    }
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
    }
    
    @IBAction func resumeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    

}
