//
//  targetScoring.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 5/31/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class targetScoring: UIViewController, UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, CellDelegate, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var targetScrollView: UIScrollView!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var removeLastButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var hitsLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var endTotalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        targetImageView.image = UIImage(named: "SingleSpot")
        targetScrollView.delegate = self
        setZoomScale()
        updateImageConstraints()
        
        //Configure aesthetics for table/buttons
        tableView.separatorStyle = .none     //Gets rid of separator line between table cells
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        removeLastButton.layer.cornerRadius = 10
        titleLabel.text = headerTitle
        
        targetImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetScoring.imageTapped(gesture:))))
//        targetImageView.gestureRecognizers?.first!.isEnabled = false
    }
    
    //MARK: Variables
    var headerTitle = ""
    var endCount = 10
    var totalScore = 0
    var targets = [UIImage]()
    var arrows = [Int]()
    var arrowLocations = [CGPoint]()
    var arrowScores: [[String]] = []    //The arrow scores are saved here as an array of strings for each end.
    var hits = 0
    var endNum = 0
    var endArrowNum = 0

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
    
    //TableView set up and management
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "endCellID") as! threeArrowEndCell
        cell.endLabel.text = "\(indexPath.row + 1)"
        cell.inputType = "target"
        cell.setUp()
        cell.delegate = self    //Set delegate to be self so that we can view the textfield data
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //Deals with delegate from the custom table cell
    func textFieldShouldEndEditing(end: Int, arrow: Int, score: String, cell: threeArrowEndCell) {
        arrowScores[end][arrow] = score
        var calc = calculateTotal()
        totalScore = calc[0]
        hits = calc[1]
        totalScoreLabel.text = "Running Total: " + String(calc[0])
        hitsLabel.text = "Hits: " + String(calc[1])
    }
    
    func calculateTotal() -> [Int] {
        var total = 0
        var hits = 0
        for x in 0...9 {
            for a in arrowScores[x] {
                if a == "X" {
                    total += 10
                    hits += 1
                }
                else if a == "M" { total += 0}
                else {
                    total += Int(a) ?? 0
                    if a == "10" || a == "9" { hits += 1 }
                }
            }
        }
        return [total, hits]
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
        arrowLocations.append(point)
        targetImageView.image = newTarget
        
        print(point)
        var score = 10 - floor(sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 500) - 6, 2)) / 450 * 10)
        if score < CGFloat(0) { score = CGFloat(0) }
        arrows.append(Int(score))
        totalScore += Int(score)
        totalScoreLabel.text = "Running Total: " + totalScore.description
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
            arrowLocations.removeLast()
            if targets.count > 0 { targetImageView.image = targets.last }
            else { targetImageView.image = UIImage(named: "SingleSpot")}
        }
    }
    
}

