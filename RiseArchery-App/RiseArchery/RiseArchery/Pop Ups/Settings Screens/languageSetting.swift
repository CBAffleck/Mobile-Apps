//
//  languageSetting.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/20/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class languageSetting: UIViewController, UITableViewDelegate, UITableViewDataSource {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    let realm = try! Realm()
    let languages = [["English", "English, en"]]
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
        return languages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if UserDefaults.standard.value(forKey: "Language") as! String == languages[0][0] {
            selectedIndexPath = IndexPath(row: 0, section: 0)
        }
        let lang = languages[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "languageCellID") as! languageCell
        cell.setInfo(title: lang[0], subtitle: lang[1])
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
        
        let newSelection = tableView.cellForRow(at: indexPath) as! languageCell
        if newSelection.accessoryType == .none {
            newSelection.accessoryType = .checkmark
            UserDefaults.standard.set(languages[indexPath.row][0], forKey: "Language")
        }
        let oldSelection = tableView.cellForRow(at: selectedIndexPath) as! languageCell
        if oldSelection.accessoryType == .checkmark {
            oldSelection.accessoryType = .none
        }
        
        selectedIndexPath = indexPath
    }

    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
