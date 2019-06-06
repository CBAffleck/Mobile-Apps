//
//  congratsScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/5/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class congratsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
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
    var inRunning: [Int] = []
    var inEndTots: [Int] = []
    var ends: [ScoringEndData] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        createEndArray()
        setUpTableView()
        detailTableView.separatorStyle = .none
        detailTableView.alwaysBounceVertical = false

        //Add border to details view
        detailsView.layer.cornerRadius = 20
        detailsView.layer.borderWidth = 0.75
        detailsView.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        
        //Add corner radius to close button and make x smaller
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
    }
    
    func createEndArray() {
        for x in 0...9 {
            let endData = ScoringEndData(a1Score: inScores[x][0], a2Score: inScores[x][1], a3Score: inScores[x][2], endTot: String(inEndTots[x]), runNum: String(inRunning[x]))
            ends.append(endData)
        }
    }
    
    //TableView set up and management
    func setUpTableView() {
        detailTableView.delegate = self
        detailTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inEndCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let end = ends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "congratsEndCell") as! congratsEndCell
        cell.endLabel.text = "\(indexPath.row + 1)"
        cell.setInfo(end: end)
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
    }
    
}

class ScoringEndData {
    var a1Score: String
    var a2Score: String
    var a3Score: String
    var endTot: String
    var runNum: String
    
    init(a1Score: String, a2Score: String, a3Score: String, endTot: String, runNum: String) {
        self.a1Score = a1Score
        self.a2Score = a2Score
        self.a3Score = a3Score
        self.endTot = endTot
        self.runNum = runNum
    }
}
