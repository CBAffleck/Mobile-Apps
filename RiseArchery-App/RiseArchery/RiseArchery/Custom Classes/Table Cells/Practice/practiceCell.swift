//
//  practiceCell.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

protocol PracticeCellDelegate {
    func didTapToPractice()
    func didTapToArrowCount()
}

class practiceCell: UITableViewCell {

    //MARK: Properties
    @IBOutlet weak var practiceButton: UIButton!
    @IBOutlet weak var arrowCountButton: UIButton!
    
    //MARK: Variables
    var delegate: PracticeCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        practiceButton.layer.cornerRadius = 10
        arrowCountButton.layer.cornerRadius = 10
    }

    //MARK: Actions
    @IBAction func practiceTapped(_ sender: UIButton) {
        print("button tapped")
        delegate?.didTapToPractice()
    }
    
    @IBAction func arrowCountTapped(_ sender: UIButton) {
        delegate?.didTapToArrowCount()
    }
    
}
