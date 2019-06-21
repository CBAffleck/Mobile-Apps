//
//  settingsScreen.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/18/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift
import MessageUI

class settingsScreen: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    //MARK: Properties
    @IBOutlet weak var settingsTitleLabel: UILabel!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: Variables
    let realm = try! Realm()
    let sections = ["Units", "Help and Support", "Other"]
    let unitItems = ["Language", "Distance Unit"]
    let settings = ["Review Rise on the App Store", "Privacy Policy", "Version"]
    let supportItems = ["Request a Feature", "Report a Bug", "Other Help"]
    var sectionContents: [[String]] = [[]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()

        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        tableView.separatorStyle = .none     //Gets rid of separator line between table cells
        tableView.showsVerticalScrollIndicator = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadData), name: NSNotification.Name(rawValue: "settingChanged"), object: nil)
        
        sectionContents = [unitItems, supportItems, settings]
    }
    
    //MARK: Functions
    @objc func reloadData() {
        tableView.reloadData()
    }
    
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sectionCellID") as! sectionCell
        cell.setInfo(title: sections[section])
        return cell.contentView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 54
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sectionContents[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = sectionContents[indexPath.section][indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "settingCellID") as! settingCell
        cell.setInfo(title: setting)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    //Handles displaying pop ups or email views depending on what setting cell is selected
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let cell = tableView.cellForRow(at: indexPath) as! settingCell
        let currTitle = cell.cellTitle
        if supportItems.contains(currTitle) {
            showMailComposer(title: currTitle)
        } else if currTitle == unitItems[0] {
            performSegue(withIdentifier: "languageSegue", sender: indexPath)
        } else if currTitle == unitItems[1] {
            performSegue(withIdentifier: "distanceSegue", sender: indexPath)
        } else if currTitle == settings[0] {
            //open app store link in app store
        } else if currTitle == settings[1] {
            performSegue(withIdentifier: "policySegue", sender: indexPath)
        }
    }
    
    //Presents the mail composer to the user with prefilled recipient, subject, and message template
    func showMailComposer(title: String) {
        guard MFMailComposeViewController.canSendMail() else {
            //show mail not configured pop up
            performSegue(withIdentifier: "mailErrorSegue", sender: self)
            print("Mail not configured")
            return
        }
        
        let composer = MFMailComposeViewController()
        composer.mailComposeDelegate = self
        composer.setToRecipients(["support@risearchery.com"])
        composer.setSubject(title)
        if title.contains("Bug") {
            composer.setMessageBody("Please describe the bug you encountered so that we can fix it and make Rise bug free again as soon as possible.\n\nBug Description: ", isHTML: false)
        } else if title.contains("Feature") {
            composer.setMessageBody("User input on the future of Rise is always appreciated, and it plays a large role in determining what features we prioritize when working on updates.\n\nPlease describe the feature you think would make a great addition to the app!\n\nFeature: ", isHTML: false)
        } else if title.contains("Other") {
            composer.setMessageBody("What can we help you with? We'll try to get back to you as soon as possible.\n\nQuestion: ", isHTML: false)
        }
        
        present(composer, animated: true)
    }
    
    //Handles mail app errors and dismissing view
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let _ = error {
            //show error pop up
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        switch result {
        case .cancelled:
            print("Cancelled")
        case .failed:
            print("Failed to send")
        case .saved:
            print("Saved")
        case .sent:
            print("Email sent")
        }
        
        controller.dismiss(animated: true, completion: nil)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }

    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
}
