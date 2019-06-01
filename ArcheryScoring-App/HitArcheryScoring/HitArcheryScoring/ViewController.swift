//
//  ViewController.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 5/31/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate {

    //MARK: Properties
    @IBOutlet weak var targetScrollView: UIScrollView!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetImageView.image = UIImage(named: "target_recurve")
        targetScrollView.delegate = self
        setZoomScale()
        updateImageConstraints()
        
        targetImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(gesture:))))
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Variables
    var score = 0

    //MARK: Functions
    func setZoomScale() {
        if let image = targetImageView.image {
            var minZoom = min(targetScrollView.bounds.size.width / image.size.width,
                              targetScrollView.bounds.size.height / image.size.height)
            if minZoom > 1 { minZoom = 1 }
            targetScrollView.minimumZoomScale = 0.7 * minZoom
            targetScrollView.zoomScale = 0.7 * minZoom
        }
    }
    
    func updateImageConstraints() {
        if let image = targetImageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let viewWidth = targetScrollView.bounds.size.width
            let viewHeight = targetScrollView.bounds.size.height
            
            var hPadding = (viewWidth - targetScrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - targetScrollView.zoomScale * imageHeight) / 2
            if vPadding < 0 { vPadding = 0 }
            
            imageConstraintLeft.constant = hPadding
            imageConstraintRight.constant = hPadding
            imageConstraintTop.constant = vPadding
            imageConstraintBottom.constant = vPadding
            
            view.layoutIfNeeded()
        }
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        updateImageConstraints()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return targetImageView
    }
    
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        let point: CGPoint = gesture.location(in: gesture.view)
        
        print(point)
        let score = 10 - floor(sqrt(pow((point.x - 500), 2) + pow((point.y - 500), 2)) / 450 * 10)
        scoreLabel.text = score.description
    }
    
}

