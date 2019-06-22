//
//  practiceScreen.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/21/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class practiceScreen: UIViewController, UIScrollViewDelegate {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var targetImageView: UIImageView!
    @IBOutlet weak var imageConstraintLeft: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintRight: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintBottom: NSLayoutConstraint!
    @IBOutlet weak var imageConstraintTop: NSLayoutConstraint!
    @IBOutlet weak var removeButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    //MARK: Variables
    let realm = try! Realm()
    var currRound = PracticeRound()
    var headerTitle = ""
    var totalScore = 0
    var arrows = [Int]()
    var arrowLocations = [CGPoint]()
    var hits = 0
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var date = ""
    let defaults = UserDefaults.standard
    var imgCount = 1
    var distance = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        headerTitle = currRound.roundName + " #" + String(currRound.roundNum)  //Set header title with number
        titleLabel.text = headerTitle
        
        targetImageView.image = loadImageFromDiskWith(fileName: currRound.targetFace)
        scrollView.delegate = self
        setZoomScale()
        updateImageConstraints()
        
        //Configure aesthetics for table/buttons
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        removeButton.layer.cornerRadius = 10
        
        //Add tap recognizer to target face image view
        targetImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(targetScoring.imageTapped(gesture:))))
        
        //Set up and start timer
        startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(resumeTimer), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        //Format start date/time into nice string
        let tempDate = Date()
        let dateFormatPrint = DateFormatter()
        dateFormatPrint.dateFormat = "h:mm a, MMM d, yyyy"      //Ex: 4:10 PM, June 8, 2019
        date = dateFormatPrint.string(from: tempDate)
    }
    
    //MARK: Functions
    func startTimer() {
        startTime = Date().timeIntervalSinceReferenceDate - elapsed
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        elapsed = Date().timeIntervalSinceReferenceDate - startTime
        timer?.invalidate()
    }
    
    @objc func updateCounter() {
        time = Date().timeIntervalSinceReferenceDate - startTime
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        let strMin = String(format: "%02d", minutes)
        let strSec = String(format: "%02d", seconds)
        timerLabel.text = strMin + ":" + strSec
    }
    
    @objc func resumeTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
    }
    
    func setZoomScale() {
        if let image = targetImageView.image {
            var minZoom = min(scrollView.bounds.size.width / image.size.width,
                              scrollView.bounds.size.height / image.size.height)
            if minZoom > 1 { minZoom = 1 }
            scrollView.minimumZoomScale = 0.7 * minZoom
            scrollView.zoomScale = 0.7 * minZoom
        }
    }
    
    //Sets target face image constraints
    func updateImageConstraints() {
        if let image = targetImageView.image {
            let imageWidth = image.size.width
            let imageHeight = image.size.height
            let viewWidth = scrollView.bounds.size.width
            let viewHeight = scrollView.bounds.size.height
            
            var hPadding = (viewWidth - scrollView.zoomScale * imageWidth) / 2
            if hPadding < 0 { hPadding = 0 }
            
            var vPadding = (viewHeight - scrollView.zoomScale * imageHeight) / 2
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
    
    //Deal with adding arrow dot and updating scores when the target face is tapped
    @objc func imageTapped(gesture: UIGestureRecognizer) {
        let point: CGPoint = gesture.location(in: gesture.view)
        let newTarget = drawImage(image: UIImage(named: "ArrowMarkGreen")!, inImage: targetImageView.image!, atPoint: point)
        saveImage(imageName: "temp" + String(imgCount), image: newTarget)
        imgCount += 1
        print(imgCount)
        //        targets.append(newTarget)
        arrowLocations.append(point)
        targetImageView.image = newTarget
        
        print(point)
        //Calculate score from tap point and update arrowScores, hits, totalScore, arrows, and labels
        var calculatedScore = calculateScore(targetType: currRound.targetFace, point: point, innerTen: currRound.innerTen)
        let score = Int(calculatedScore[0])
        //Update hits if needed
        if score == 10 || score == 9 {
            hits += 1
        }
        arrows.append(score!)
        totalScore += score!
    }

    //Calculates score based on type of target face being used
    func calculateScore(targetType : String, point : CGPoint, innerTen : String) -> [String] {
        var distFromCenter = CGFloat()
        var score = Int()
        var scoreString = ""
        if targetType == "SingleSpot" {
            distFromCenter = sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 500) - 6, 2))
            score = Int(10 - floor(distFromCenter / 45))    //Recurve rings are 45 pixels wide
            if score < 0 { score = 0 }      //Deal with taps outside the 1 ring
            if distFromCenter < 22.5 { scoreString = "X"}
            else { scoreString = String(score) }
        } else if targetType == "CompoundSingleSpot" {
            distFromCenter = sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 500) - 6, 2))
            score = Int(10 - floor(distFromCenter / 75))    //Compound rings are 75 pixels wide
            if score < 5 { score = 0 }      //Compound target only goes down to the 5 ring
            if distFromCenter < 37.5 { scoreString = "X"}
            else { scoreString = String(score) }
        } else if targetType == "Triangle3Spot" {
            //Distance from pixel center of each spot on the 3 spot
            let distFromTopCenter = sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 275) - 6, 2))
            let distFromLeftCenter = sqrt(pow(abs(point.x - 253) - 6, 2) + pow(abs(point.y - 725) - 6, 2))
            let distFromRightCenter = sqrt(pow(abs(point.x - 748) - 6, 2) + pow(abs(point.y - 725) - 6, 2))
            distFromCenter = min(distFromTopCenter, distFromLeftCenter, distFromRightCenter)
            score = Int(10 - floor(distFromCenter / 45))    //Rings on the triangle 3 spot are 45 pixels wide
            if score < 6 { score = 0 }      //3 spot targets only go down to the 6 ring
            scoreString = String(score)
            //If the value of innerTen is true (for compound archers at indoor distances), then only the inner 10 counts as 10, and the rest of the gold is a 9
            if innerTen == "on" {
                if distFromCenter > 22.5 && distFromCenter < 90 {
                    score = 9
                    scoreString = "9"
                }
            } else {
                if distFromCenter < 22.5 { scoreString = "X" }
            }
        } else if targetType == "Vertical3Spot" {
            //Distance from pixel center of each spot on the 3 spot
            let distFromTopCenter = sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 195) - 6, 2))
            let distFromMiddleCenter = sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 500) - 6, 2))
            let distFromBottomCenter = sqrt(pow(abs(point.x - 500) - 6, 2) + pow(abs(point.y - 805) - 6, 2))
            distFromCenter = min(distFromTopCenter, distFromMiddleCenter, distFromBottomCenter)
            score = Int(10 - floor(distFromCenter / 29))    //Rings on the vertical 3 spot are 29 pixels wide
            if score < 6 { score = 0 }      //3 spot targets only go down to the 6 ring
            scoreString = String(score)
            //If the value of innerTen is true (for compound archers at indoor distances), then only the inner 10 counts as 10, and the rest of the gold is a 9
            if innerTen == "on" {
                if distFromCenter > 14.5 && distFromCenter < 58 {
                    score = 9
                    scoreString = "9"
                }
            } else {
                if distFromCenter < 14.5 { scoreString = "X" }
            }
        }
        if score == 0 { scoreString = "M" }
        return [String(score), scoreString]
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    //MARK: Actions
    @IBAction func removeTapped(_ sender: UIButton) {
        if imgCount > 1 {
            
            //Set target image to last image without most recent arrow mark by deleting current image from disk and fetching last target image from disk
            imgCount -= 1
            if imgCount > 0 {
                print(imgCount)
                removeImage(imageName: "temp" + String(imgCount))
                imgCount -= 1
                let newImage = loadImageFromDiskWith(fileName: "temp" + String(imgCount))
                //Need to resize because the images saved to disk are loaded from disk as 3000x3000px
                UIGraphicsBeginImageContext(CGSize(width: 1000, height: 1000))
                newImage.draw(in: CGRect(x: 0, y: 0, width: 1000, height: 1000))
                let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                if imgCount == 0 { targetImageView.image = loadImageFromDiskWith(fileName: currRound.targetFace) }
                else { targetImageView.image = scaledImage }
                imgCount += 1
            }
            
            //Remove arrow score from total
            totalScore -= arrows.last!
            //Remove last hit from hits if necessary
            if !arrows.isEmpty {
                if arrows.last == 10 || arrows.last == 9 {
                    hits -= 1
                }
            }
            //Remove last arrow score and location from corresponding lists
            arrows.removeLast()
            arrowLocations.removeLast()
        }
    }
    @IBAction func finishTapped(_ sender: UIButton) {
        stopTimer()
    }
    @IBAction func cancelTapped(_ sender: UIButton) {
    }
    
}
