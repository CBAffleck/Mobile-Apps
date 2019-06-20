//
//  distanceSetting.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/19/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class distanceSetting: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var screenTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    let distances = ["Metric (meters)", "Imperial (yards)"]
    var selectedIndexPath : IndexPath = IndexPath(row: 0, section: 0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        tableView.separatorStyle = .none     //Gets rid of separator line between table cells
        tableView.showsVerticalScrollIndicator = false
        
        setUpTableView()
    }

    //MARK: Functions
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return distances.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserDefaults.standard.value(forKey: "DistanceUnit") as! String == distances[1] {
            selectedIndexPath = IndexPath(row: 1, section: 0)
        }
        let dist = distances[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "distanceCellID") as! distanceCell
        cell.setInfo(title: dist)
        if indexPath == selectedIndexPath { cell.accessoryType = .checkmark }
        else { cell.accessoryType = .none }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //Handles displaying pop ups or email views depending on what setting cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath == selectedIndexPath { return }
        
        let newSelection = tableView.cellForRow(at: indexPath) as! distanceCell
        if newSelection.accessoryType == .none {
            newSelection.accessoryType = .checkmark
            UserDefaults.standard.set(distances[indexPath.row], forKey: "DistanceUnit")
        }
        let oldSelection = tableView.cellForRow(at: selectedIndexPath) as! distanceCell
        if oldSelection.accessoryType == .checkmark {
            oldSelection.accessoryType = .none
        }
        
        selectedIndexPath = indexPath
    }
    
    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "settingChanged"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
}
