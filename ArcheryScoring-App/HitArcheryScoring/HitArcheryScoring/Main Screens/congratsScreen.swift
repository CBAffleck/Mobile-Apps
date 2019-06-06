//
//  congratsScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class congratsScreen: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var detailsView: UIView!
    @IBOutlet weak var detailTitleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var endColLabel: UILabel!
    @IBOutlet weak var totColLabel: UILabel!
    @IBOutlet weak var runColLabel: UILabel!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var hitsLabel: UILabel!
    
    
    //MARK: Variables
    var inScores: [[String]] = []
    var inTotal = 0
    var inHits = 0
    var inEndCount = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //Add border to details view
        detailsView.layer.cornerRadius = 20
        detailsView.layer.borderWidth = 0.75
        detailsView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        
        //Add corner radius to close button and make x smaller
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: Actions

}
