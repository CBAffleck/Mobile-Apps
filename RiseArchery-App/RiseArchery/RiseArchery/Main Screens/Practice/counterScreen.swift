//
//  counterScreen.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/22/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class counterScreen: UIViewController {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var constainingView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    
    //MARK: Variables
    var count = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonSetUp()
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        countLabel.text = String(count)
    }

    //MARK: Functions
    func buttonSetUp() {
        let buttons = [plusButton, minusButton]
        for b in buttons {
            b?.layer.cornerRadius = 0.5 * (b?.bounds.size.width)!
            b?.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    //MARK: Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
    }
    @IBAction func finishTapped(_ sender: UIButton) {
    }
    @IBAction func minusTapped(_ sender: UIButton) {
        if count != 0 {
            count -= 1
            countLabel.text = String(count)
        }
    }
    @IBAction func plusTapped(_ sender: UIButton) {
        count += 1
        countLabel.text = String(count)
    }
    
    
}
