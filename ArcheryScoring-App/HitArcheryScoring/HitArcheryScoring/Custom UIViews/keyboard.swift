//
//  keyboard.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

protocol KeyboardDelegate: class {
    func keyWasTapped(character: String)
}

class keyboard: UIView {

    //MARK: Properties
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var b4: UIButton!
    @IBOutlet weak var b5: UIButton!
    @IBOutlet weak var b6: UIButton!
    @IBOutlet weak var b7: UIButton!
    @IBOutlet weak var b8: UIButton!
    @IBOutlet weak var b9: UIButton!
    @IBOutlet weak var bm: UIButton!
    @IBOutlet weak var b10: UIButton!
    @IBOutlet weak var bx: UIButton!
    
    
    //MARK: Variables
    weak var delegate: KeyboardDelegate?
    var buttons: [UIButton] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initializeSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initializeSubviews()
    }
    
    func initializeSubviews() {
        let xibFileName = "keyboard"
        let view = Bundle.main.loadNibNamed(xibFileName, owner: self, options: nil)![0] as! UIView
        self.addSubview(view)
        view.frame = self.bounds
        //Apply corner radius and drop shadow to all buttons in keyboard
        buttons = [b1, b2, b3, b4, b5, b6, b7, b8, b9, b10, bx, bm]
        for b in buttons {
            b.layer.cornerRadius = 5
            b.layer.masksToBounds = false
            b.layer.shadowColor = UIColor(red: 132/255, green: 134/255, blue: 136/255, alpha: 1.0).cgColor
            b.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
            b.layer.shadowOpacity = 1.0
            b.layer.shadowRadius = 0.0
        }
    }
    
    //MARK: Actions
    @IBAction func keyTapped(_ sender: UIButton) {
        self.delegate?.keyWasTapped(character: sender.titleLabel!.text!)
    }

}
