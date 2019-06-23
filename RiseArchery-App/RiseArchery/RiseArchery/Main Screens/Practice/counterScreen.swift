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
    @IBOutlet weak var dimView: UIView!
    
    //MARK: Variables
    var count = 0
    var scoringType = "counter"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonSetUp()
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        countLabel.text = String(count)
        
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "dismissDimView"), object: nil)
    }

    //MARK: Functions
    func buttonSetUp() {
        let buttons = [plusButton, minusButton]
        for b in buttons {
            b?.layer.cornerRadius = 0.5 * (b?.bounds.size.width)!
            b?.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        }
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.isHidden = false
            self.dimView.alpha = 1
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.alpha = 0
        })
        self.dimView.isHidden = true
    }
    
    @objc func dismissEffect() {
        animateOut()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "counterCancelSegue" {
            let vc = segue.destination as? cancelScoring
            vc?.scoringType   = scoringType
        } else if segue.identifier == "saveCounterSegue" {
            let vc = segue.destination as? saveCounter
            vc?.count = count
        }
    }
    
    //MARK: Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        animateIn()
    }
    @IBAction func finishTapped(_ sender: UIButton) {
        animateIn()
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
