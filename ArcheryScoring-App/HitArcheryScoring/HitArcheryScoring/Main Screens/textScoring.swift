//
//  textScoring.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class textScoring: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var scoringTable: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var hitLabel: UILabel!
    
    
    //MARK: Variables
    var endCount = 10
    var headerTitle = ""
    var arrowScores: [[String]] = []    //The arrow scores are saved here as an array of strings for each end.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        self.hideKeyboardOnTap()
        scoringTable.separatorStyle = .none     //Gets rid of separator line between table cells
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        titleLabel.text = headerTitle
        //Set up arrowScores array so that the values can be updated as arrow scores are recorded
        for _ in 0...9 {
            arrowScores.append(["0", "0", "0"])
        }
    }
    
    //TableView set up and management
    func setUpTableView() {
        scoringTable.delegate = self
        scoringTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "endCellID") as! threeArrowEndCell
        cell.endLabel.text = "\(indexPath.row + 1)"
        cell.setUp()
        cell.delegate = self    //Set delegate to be self so that we can view the textfield data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //Deals with delegate from the custom table cell
    func textFieldShouldEndEditing(end: Int, arrow: Int, score: String, cell: threeArrowEndCell) {
        arrowScores[end][arrow] = score
        var calc = calculateTotal()
        runningLabel.text = "Running Total: " + String(calc[0])
        hitLabel.text = "Hits: " + String(calc[1])
    }
    
    func calculateTotal() -> [Int] {
        var total = 0
        var hits = 0
        for x in 0...9 {
            for a in arrowScores[x] {
                if a == "X" {
                    total += 10
                    hits += 1
                }
                else if a == "M" { total += 0}
                else {
                    total += Int(a) ?? 0
                    if a == "10" || a == "9" { hits += 1 }
                }
            }
        }
        return [total, hits]
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
        print(arrowScores)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
    }
    
}
