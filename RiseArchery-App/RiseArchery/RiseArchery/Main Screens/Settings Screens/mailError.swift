//
//  mailError.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/19/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class mailError: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var okButton: UIButton!
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        popUpView.layer.cornerRadius = 20
        okButton.layer.cornerRadius = 10
    }

    //MARK: Actions
    @IBAction func okTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
