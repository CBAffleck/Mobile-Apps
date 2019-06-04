//
//  HomeScreen.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/2/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class HomeScreen: UIViewController, UIGestureRecognizerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var profileIcon: UIImageView!
    @IBOutlet weak var scoringIcon: UIImageView!
    @IBOutlet weak var historyIcon: UIImageView!
    @IBOutlet weak var scoringLabel: UILabel!
    @IBOutlet weak var profileLabel: UILabel!
    @IBOutlet weak var historyLabel: UILabel!
    @IBOutlet weak var profileButton: UIButton!
    @IBOutlet weak var historyButton: UIButton!
    @IBOutlet weak var scoringButton: UIButton!
    @IBOutlet weak var strongShotsLabel: UILabel!
    @IBOutlet weak var navBarView: UIView!
    
    //MARK: Variables
    var roundCount = 1
    var roundsHeight = CGFloat(0)
    let scrollView : UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.isScrollEnabled = true
        return v
    }()
    let contentView : UIView = {
        let c = UIView()
        return c
    }()
    let favLabel : UILabel = {
        let favorites = UILabel()
        favorites.text = "Favorites"
        favorites.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.regular)
        favorites.textColor = UIColor(red: 177/255.0, green: 177/255.0, blue: 177/255.0, alpha: 1.0)
        return favorites
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLayout()
    }
    
    func setUpLayout() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: strongShotsLabel.bottomAnchor, constant: 10).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: navBarView.topAnchor).isActive = true
        
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor).isActive = true
        contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor).isActive = true
        
        scrollView.addSubview(favLabel)
        favLabel.translatesAutoresizingMaskIntoConstraints = false
        favLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20).isActive = true
        favLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 20).isActive = true
        favLabel.widthAnchor.constraint(equalToConstant: 275).isActive = true
        favLabel.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        let stockIndoorRound = customScoringRoundView(frame: CGRect(), title: "18m Scoring Round", last: "Last Scored: 2 days ago", desc: "10 ends, 3 arrows per end", avg: "Average: 260", pr: "Personal Best: 275")
        contentView.addSubview(stockIndoorRound)
        stockIndoorRound.translatesAutoresizingMaskIntoConstraints = false
        stockIndoorRound.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        stockIndoorRound.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 62).isActive = true
        stockIndoorRound.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        roundsHeight += stockIndoorRound.frame.height + CGFloat(20)
        
        let num = 8
        while roundCount < num {
            let newRound = customScoringRoundView(frame: CGRect(), title: "18m Scoring Round", last: "Last Scored: 2 days ago", desc: "10 ends, 3 arrows per end", avg: "Average: --", pr: "Personal Best: --")
            let dist = roundCount * 151 + roundCount * 20 + 62
            contentView.addSubview(newRound)
            newRound.translatesAutoresizingMaskIntoConstraints = false
            newRound.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
            newRound.topAnchor.constraint(equalTo: contentView.topAnchor, constant: CGFloat(dist)).isActive = true
            newRound.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
            roundsHeight += newRound.frame.height + CGFloat(20)
            roundCount += 1
        }
        
        if roundsHeight > scrollView.frame.height {
            contentView.subviews[contentView.subviews.count - 1].bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -171).isActive = true
        }
    }
    
    //MARK: Actions
    @IBAction func toProfileScreen(_ sender: UIButton) {
    }
    
    @IBAction func toHistoryScreen(_ sender: UIButton) {
    }
    
    @IBAction func toScoringScreen(_ sender: UIButton) {
    }
    
    @IBAction func openScoringPopUp(_ sender: UIButton) {
    }
    
}
