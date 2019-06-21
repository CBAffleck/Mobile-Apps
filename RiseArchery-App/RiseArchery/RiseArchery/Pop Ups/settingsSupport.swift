//
//  settingsSupport.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/19/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class settingsSupport: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    //MARK: Variables
    let realm = try! Realm()
    let supportItems = ["Language", "Distance Unit", "Help and Support", "Review Rise on the App Store", "Privacy Policy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: Functions
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return supportItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = supportItems[indexPath.row]
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

}
