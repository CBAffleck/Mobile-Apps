//
//  privacyPolicySetting.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/20/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class privacyPolicySetting: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var bodyView: UITextView!
    
    //MARK: Variables

    override func viewDidLoad() {
        super.viewDidLoad()

        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        
        bodyView.text = setPolicy()
    }
    
    //MARK: Functions
    func setPolicy() -> String {
        let body = "The privacy policy for the current version of Rise is pretty straightforward: any data you enter into the app is stored locally, on your phone, and can not be accessed by anyone else. This includes setting your profile picture, name, bow type, PRs, and all scoring rounds viewable on the History tab. If you choose to delete Rise from your device, any information saved in the app will be permanently deleted.\n\nIn the event that features are added to Rise in the future that impact how your data is saved or stored, this policy will be updated to reflect those changes."
        return body
    }
    
    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
