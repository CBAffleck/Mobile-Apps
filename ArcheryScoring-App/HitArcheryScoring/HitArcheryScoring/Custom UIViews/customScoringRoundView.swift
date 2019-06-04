//
//  customScoringRoundView.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/3/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class customScoringRoundView: UIView {
    
    let contentView : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 20
        view.layer.borderWidth = 0.5
        view.layer.borderColor = UIColor(red: 191/255.0, green: 191/255.0, blue: 191/255.0, alpha: 1.0).cgColor
        return view
    }()
    
    let roundTitle : UILabel = {
        let roundLabel = UILabel()
        roundLabel.text = "18m Scoring Round"
        roundLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.semibold)
        roundLabel.adjustsFontSizeToFitWidth = true
        return roundLabel
    }()
    
    let roundDescription : UILabel = {
        let descLabel = UILabel()
        descLabel.text = "10 ends, 3 arrows per end"
        descLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        descLabel.adjustsFontSizeToFitWidth = true
        descLabel.textColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)
        return descLabel
    }()
    
    let lastRound : UILabel = {
        let lastLabel = UILabel()
        lastLabel.text = "Last Scored: "
        lastLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        lastLabel.adjustsFontSizeToFitWidth = true
        lastLabel.textColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)
        return lastLabel
    }()
    
    let average : UILabel = {
        let avgLabel = UILabel()
        avgLabel.text = "Average: "
        avgLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        avgLabel.adjustsFontSizeToFitWidth = true
        avgLabel.textColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)
        return avgLabel
    }()
    
    let record : UILabel = {
        let prLabel = UILabel()
        prLabel.text = "Personal Best: "
        prLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.semibold)
        prLabel.adjustsFontSizeToFitWidth = true
        prLabel.textColor = UIColor(red: 61/255.0, green: 61/255.0, blue: 61/255.0, alpha: 1.0)
        return prLabel
    }()
    
    init(frame: CGRect, title : String, last : String, desc : String, avg : String, pr : String) {
        super.init(frame: frame)
        self.roundTitle.text = title
        self.lastRound.text = last
        self.roundDescription.text = desc
        self.average.text = avg
        self.record.text = pr
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(contentView)
        self.addSubview(roundTitle)
        self.addSubview(lastRound)
        self.addSubview(roundDescription)
        self.addSubview(average)
        self.addSubview(record)
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 151).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 40).isActive = true
        
        roundTitle.translatesAutoresizingMaskIntoConstraints = false
        roundTitle.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        roundTitle.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20).isActive = true
        roundTitle.widthAnchor.constraint(equalToConstant: 275).isActive = true
        roundTitle.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        lastRound.translatesAutoresizingMaskIntoConstraints = false
        lastRound.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        lastRound.topAnchor.constraint(equalTo: roundTitle.topAnchor, constant: 20).isActive = true
        lastRound.widthAnchor.constraint(equalToConstant: 275).isActive = true
        lastRound.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        roundDescription.translatesAutoresizingMaskIntoConstraints = false
        roundDescription.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        roundDescription.topAnchor.constraint(equalTo: lastRound.topAnchor, constant: 28).isActive = true
        roundDescription.widthAnchor.constraint(equalToConstant: 275).isActive = true
        roundDescription.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        average.translatesAutoresizingMaskIntoConstraints = false
        average.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        average.topAnchor.constraint(equalTo: roundDescription.topAnchor, constant: 20).isActive = true
        average.widthAnchor.constraint(equalToConstant: 275).isActive = true
        average.heightAnchor.constraint(equalToConstant: 22).isActive = true
        
        record.translatesAutoresizingMaskIntoConstraints = false
        record.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 20).isActive = true
        record.topAnchor.constraint(equalTo: average.topAnchor, constant: 20).isActive = true
        record.widthAnchor.constraint(equalToConstant: 275).isActive = true
        record.heightAnchor.constraint(equalToConstant: 22).isActive = true
    }

}
