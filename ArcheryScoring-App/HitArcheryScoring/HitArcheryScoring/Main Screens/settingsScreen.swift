//
//  settingsScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/18/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class settingsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    let settings = ["Language", "Distance Unit", "Help and Support", "Review on the App Store", "Privacy Policy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()

        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        tableView.separatorStyle = .none     //Gets rid of separator line between table cells
        tableView.showsVerticalScrollIndicator = false
    }
    
    //MARK: Functions
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = settings[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellID") as! settingCell
        cell.setInfo(title: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
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
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
