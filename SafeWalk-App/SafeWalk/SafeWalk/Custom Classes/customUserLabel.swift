//
//  customUserLabel.swift
//  SafeWalk
//
//  Created by Campbell Affleck on 2/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class customUserLabel: UIView {
    
    init(frame: CGRect, name : String, img : String) {
        super.init(frame: frame)
        self.userName.text = name
        self.userImage.image = UIImage(named: img)
        setupViews()
        setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        self.addSubview(contentView)
        self.addSubview(userImage)
        self.addSubview(userName)
    }
    
    func setupConstraints() {
        self.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
        contentView.topAnchor.constraint(equalTo: self.topAnchor, constant: 10).isActive = true
        contentView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 20).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        contentView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 50).isActive = true
        
        userImage.translatesAutoresizingMaskIntoConstraints = false
        userImage.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 0).isActive = true
        userImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 40).isActive = true
        userImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        userName.translatesAutoresizingMaskIntoConstraints = false
        userName.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 20).isActive = true
        userName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        userName.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    let contentView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.blue
        return view
    }()
    
    let userImage : UIImageView = {
        let img = UIImage(named: "UserIcon.png")
        let imgView = UIImageView(image: img)
        imgView.frame.size = CGSize(width: 20, height: 20)
        imgView.layer.cornerRadius = 20
        imgView.clipsToBounds = true
        return imgView
    }()

    let userName : UILabel = {
        let nameView = UILabel()
        nameView.text = "Firstname Lastname"
        nameView.font = nameView.font.withSize(20)
        nameView.adjustsFontSizeToFitWidth = true
        return nameView
    }()
    
}
