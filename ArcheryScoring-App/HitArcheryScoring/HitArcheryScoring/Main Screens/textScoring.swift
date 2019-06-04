//
//  textScoring.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class textScoring: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var scoringTable: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    
    //MARK: Variables
    var endCount = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        scoringTable.separatorStyle = .none
    }
    
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
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
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
    @IBAction func finishTapped(_ sender: UIButton) {
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
    }
    
}
