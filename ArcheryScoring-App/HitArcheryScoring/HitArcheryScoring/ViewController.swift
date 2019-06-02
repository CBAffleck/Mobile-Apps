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
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var removeLastButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        targetImageView.image = UIImage(named: "40cmSingleSpot")
        targetScrollView.delegate = self
        setZoomScale()
        updateImageConstraints()
        
        targetImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ViewController.imageTapped(gesture:))))
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    //MARK: Variables
    var totalScore = 0
    var targets = [UIImage]()
    var arrows = [Int]()

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
        let newTarget = drawImage(image: UIImage(named: "ArrowMarkGreen")!, inImage: targetImageView.image!, atPoint: point)
        targets.append(newTarget)
        targetImageView.image = newTarget
        
        print(point)
        let score = 10 - floor(sqrt(pow((point.x - 500), 2) + pow((point.y - 500), 2)) / 450 * 10)
        scoreLabel.text = score.description
        arrows.append(Int(score))
        totalScore += Int(score)
        totalScoreLabel.text = totalScore.description
    }
    
    func drawImage(image foreGroundImage: UIImage, inImage backgroundImage: UIImage, atPoint point: CGPoint) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(backgroundImage.size, false, 0.0)
        let renderSize: CGFloat = 15
        backgroundImage.draw(in: CGRect.init(x: 0, y: 0, width: backgroundImage.size.width, height: backgroundImage.size.height))
        let xPoint = point.x - renderSize / 2
        let yPoint = point.y - renderSize / 2
        foreGroundImage.draw(in: CGRect.init(x: xPoint, y: yPoint, width: renderSize, height: renderSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    @IBAction func removeLastArrow(_ sender: UIButton) {
        if !targets.isEmpty {
            targetImageView.image = targets.last
            targets.removeLast()
            totalScore -= arrows.last!
            totalScoreLabel.text = totalScore.description
            arrows.removeLast()
            if targets.count > 0 { targetImageView.image = targets.last }
            else { targetImageView.image = UIImage(named: "40cmSingleSpot")}
        }
    }
    
}

