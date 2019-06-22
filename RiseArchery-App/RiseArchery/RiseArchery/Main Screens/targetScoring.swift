//
//  targetScoring.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 5/31/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

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
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var dimView: UIView!
    
    //MARK: Variables
    let realm = try! Realm()
    var currRound = ScoringRound()
    var headerTitle = ""
    var totalScore = 0
    var arrows = [Int]()
    var arrowLocations = [CGPoint]()
    var arrowScores: [[String]] = []    //The arrow scores are saved here as an array of strings for each end.
    var hits = 0
    var endNum = 0
    var endArrowNum = 0
    var threeEndCells: [threeArrowEndCell] = []
    var sixEndCells: [sixArrowEndCell] = []
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var date = ""
    let scoringType = "target"
    let defaults = UserDefaults.standard
    var imgCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pop up background dimming stuff
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        headerTitle = currRound.roundName + " #" + String(currRound.roundNum)  //Set header title with number
        //Put cells in array so they aren't reused when the tableview scrolls
        for x in 1...currRound.endCount {
            if currRound.arrowsPerEnd == 3 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "endCellID") as! threeArrowEndCell
                cell.endLabel.text = String(x)
                cell.inputType = scoringType
                cell.setUp()
                cell.delegate = self
                threeEndCells.append(cell)
            } else {
                let cell2 = tableView.dequeueReusableCell(withIdentifier: "sixEndCellID") as! sixArrowEndCell
                cell2.endLabel.text = String(x)
                cell2.inputType = scoringType
                cell2.setUp()
                cell2.delegate = self
                sixEndCells.append(cell2)
            }
        }
        
        setUpTableView()
        tableView.isUserInteractionEnabled = false
        targetImageView.image = loadImageFromDiskWith(fileName: currRound.targetFace)
        targetScrollView.delegate = self
        setZoomScale()
        updateImageConstraints()
        
        //Set up arrowScores array so that the values can be updated as arrow scores are recorded
        for _ in 0...currRound.endCount - 1 {
            arrowScores.append([String](repeating: "0", count: currRound.arrowsPerEnd))
        }
        
        //Configure aesthetics for table/buttons
        tableView.separatorStyle = .none     //Gets rid of separator line between table cells
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        removeLastButton.layer.cornerRadius = 10
        titleLabel.text = headerTitle
        
        //Set textfield border of first arrow field
        let indexPath = IndexPath(row: endNum, section: 0)
        if currRound.arrowsPerEnd == 3 {
            let cell = tableView.cellForRow(at: indexPath) as! threeArrowEndCell
            cell.arrow1Field.layer.borderWidth = 2.0
            cell.arrow1Field.layer.borderColor = UIColor.black.cgColor
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! sixArrowEndCell
            cell.arrow1Field.layer.borderWidth = 2.0
            cell.arrow1Field.layer.borderColor = UIColor.black.cgColor
        }
        
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
        return currRound.endCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currRound.arrowsPerEnd == 3 {
            let cell = threeEndCells[indexPath.row]
            return cell
        } else {
            let cell2 = sixEndCells[indexPath.row]
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //Deals with delegate from the custom table cell
    func textFieldShouldEndEditing(end: Int, arrow: Int, score: String) {
        //Delegate does nothing on the target screen
    }
    
    func textFieldBeganEditing(row: Int, showKB: Bool, hideKB: Bool) {
        //do nothing
    }
    
    //Sets target face image constraints
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
        let scoreString = calculatedScore[1]
        //Update hits if needed
        if score == 10 || score == 9 {
            hits += 1
            hitsLabel.text = "Hits: " + String(hits)
        }
        arrows.append(score!)
        arrowScores[endNum][endArrowNum] = scoreString
        totalScore += score!
        totalScoreLabel.text = "Running Total: " + totalScore.description
        applyArrowInfo(score: scoreString)
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
    
    //Fill in field with arrow score and change colors to match
    func applyArrowInfo(score: String) {
        let indexPath = IndexPath(row: endNum, section: 0)
        tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
        //Calculate new end total after each arrow
        let endTot = calculateEndTotal(arrows: arrowScores[endNum])
        //Deal with arrow info depending on if the cell is a threeArrow or sixArrow type
        if currRound.arrowsPerEnd == 3 {
            let cell = tableView.cellForRow(at: indexPath) as! threeArrowEndCell
            cell.totalLabel.text = String(endTot)
            if endArrowNum == 0 {
                cell.arrow1Field.text = score
                applyEndColorsThree(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 1 {
                cell.arrow2Field.text = score
                applyEndColorsThree(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 2 {
                cell.arrow3Field.text = score
                applyEndColorsThree(cell: cell, score: score)
                triggerNextEnd()
            }
        } else {
            let cell = tableView.cellForRow(at: indexPath) as! sixArrowEndCell
            cell.totalLabel.text = String(endTot)
            if endArrowNum == 0 {
                cell.arrow1Field.text = score
                applyEndColorsSix(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 1 {
                cell.arrow2Field.text = score
                applyEndColorsSix(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 2 {
                cell.arrow3Field.text = score
                applyEndColorsSix(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 3 {
                cell.arrow4Field.text = score
                applyEndColorsSix(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 4 {
                cell.arrow5Field.text = score
                applyEndColorsSix(cell: cell, score: score)
                endArrowNum += 1
            } else if endArrowNum == 5 {
                cell.arrow6Field.text = score
                applyEndColorsSix(cell: cell, score: score)
                triggerNextEnd()
            }
        }
    }
    
    func triggerNextEnd() {
        endArrowNum = 0
        endNum += 1
        if endNum == currRound.endCount {
            targetImageView.gestureRecognizers?.first!.isEnabled = false
        } else {
            let nextIndexPath = IndexPath(row: endNum, section: 0)
            tableView.scrollToRow(at: nextIndexPath, at: .middle, animated: true)
            if currRound.arrowsPerEnd == 3 {
                let nextCell = tableView.cellForRow(at: nextIndexPath) as! threeArrowEndCell
                nextCell.arrow1Field.layer.borderWidth = 2.0
                nextCell.arrow1Field.layer.borderColor = UIColor.black.cgColor
            } else {
                let nextCell = tableView.cellForRow(at: nextIndexPath) as! sixArrowEndCell
                nextCell.arrow1Field.layer.borderWidth = 2.0
                nextCell.arrow1Field.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func calculateEndTotal(arrows : [String]) -> Int {
        var total = 0
        for a in arrows {
            if a == "X" { total += 10}
            else if a == "M" { total += 0}
            else { total += Int(a) ?? 0}
        }
        return total
    }
    
    //3 arrow ends: Apply background color to field score was just put in, and move "active field" border to next field
    func applyEndColorsThree(cell : threeArrowEndCell, score : String) {
        if endArrowNum == 0 {
            cell.arrow1Field.layer.borderWidth = 0.0
            cell.arrow1Field.backgroundColor = determineEndColor(score: score)
            cell.arrow2Field.layer.borderWidth = 2.0
            cell.arrow2Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 1 {
            cell.arrow2Field.layer.borderWidth = 0.0
            cell.arrow2Field.backgroundColor = determineEndColor(score: score)
            cell.arrow3Field.layer.borderWidth = 2.0
            cell.arrow3Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 2 {
            cell.arrow3Field.layer.borderWidth = 0.0
            cell.arrow3Field.backgroundColor = determineEndColor(score: score)
            cell.cellView.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
            cell.endLabel.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
            cell.totalLabel.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
        }
    }
    
    //6 arrow ends: Apply background color to field score was just put in, and move "active field" border to next field
    func applyEndColorsSix(cell : sixArrowEndCell, score : String) {
        if endArrowNum == 0 {
            cell.arrow1Field.layer.borderWidth = 0.0
            cell.arrow1Field.backgroundColor = determineEndColor(score: score)
            cell.arrow2Field.layer.borderWidth = 2.0
            cell.arrow2Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 1 {
            cell.arrow2Field.layer.borderWidth = 0.0
            cell.arrow2Field.backgroundColor = determineEndColor(score: score)
            cell.arrow3Field.layer.borderWidth = 2.0
            cell.arrow3Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 2 {
            cell.arrow3Field.layer.borderWidth = 0.0
            cell.arrow3Field.backgroundColor = determineEndColor(score: score)
            cell.arrow4Field.layer.borderWidth = 2.0
            cell.arrow4Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 3 {
            cell.arrow4Field.layer.borderWidth = 0.0
            cell.arrow4Field.backgroundColor = determineEndColor(score: score)
            cell.arrow5Field.layer.borderWidth = 2.0
            cell.arrow5Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 4 {
            cell.arrow5Field.layer.borderWidth = 0.0
            cell.arrow5Field.backgroundColor = determineEndColor(score: score)
            cell.arrow6Field.layer.borderWidth = 2.0
            cell.arrow6Field.layer.borderColor = UIColor.black.cgColor
        } else if endArrowNum == 5 {
            cell.arrow6Field.layer.borderWidth = 0.0
            cell.arrow6Field.backgroundColor = determineEndColor(score: score)
            cell.cellView.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
            cell.endLabel.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
            cell.totalLabel.backgroundColor = UIColor(red: 234/255, green: 250/255, blue: 240/255, alpha: 1.0)
        }
    }
    
    //Determine what color to use when changing background color of arrow field to match score
    func determineEndColor(score : String) -> UIColor {
        if ["M", "1", "2"].contains(score) {
            return UIColor.white
        } else if ["3", "4"].contains(score) {
            return UIColor(red: 193/255, green: 193/255, blue: 193/255, alpha: 1.0)
        } else if ["5", "6"].contains(score) {
            return UIColor(red: 171/255, green: 194/255, blue: 255/255, alpha: 1.0)
        } else if ["7", "8"].contains(score) {
            return UIColor(red: 255/255, green: 171/255, blue: 171/255, alpha: 1.0)
        } else {    //If the score is 9, 10, or X
            return UIColor(red: 255/255, green: 252/255, blue: 171/255, alpha: 1.0)
        }
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
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "targetToFinishSegue" {
            let vc = segue.destination as? finishScoring
            vc?.aScores = arrowScores
            vc?.totalScore = totalScore
            vc?.hits = hits
            vc?.headerTitle = headerTitle
            vc?.timerValue = timerLabel.text!
            vc?.startDate = date
            vc?.scoringType = scoringType
            vc?.aLocations = arrowLocations
            vc?.targetImage = targetImageView.image!
            vc?.currRound = currRound
            vc?.roundNum = currRound.roundNum
            vc?.imgCount = imgCount
        } else if segue.identifier == "targetToCancelSegue" {
            let vc = segue.destination as? cancelScoring
            vc?.imgCount = imgCount
            vc?.scoringType = scoringType
        }
    }
    
    func animateIn() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.isHidden = false
            self.dimView.alpha = 1
        })
    }
    
    func animateOut() {
        UIView.animate(withDuration: 0.2, animations: {
            self.dimView.alpha = 0
        })
        self.dimView.isHidden = true
    }
    
    @objc func dismissEffect() {
        animateOut()
    }
    
    //MARK: Remove Button
    @IBAction func removeLastArrow(_ sender: UIButton) {
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
            //Remove arrow score from running total
            
            totalScore -= arrows.last!
            totalScoreLabel.text = "Running Total: " + totalScore.description
            //Remove last hit from hits if necessary
            if !arrows.isEmpty {
                if arrows.last == 10 || arrows.last == 9 {
                    hits -= 1
                    hitsLabel.text = "Hits: " + String(hits)
                }
            }
            //Remove last arrow score and location from corresponding lists
            arrows.removeLast()
            arrowLocations.removeLast()
            
            if endNum != currRound.endCount {
                //Get current cell
                let indexPath = IndexPath(row: endNum, section: 0)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
                if currRound.arrowsPerEnd == 3 {
                    let cell = tableView.cellForRow(at: indexPath) as! threeArrowEndCell
                    //Reset current cell to look like the next cell
                    if endArrowNum == 0 {
                        if endNum == 0 {
                            //do nothing
                        } else {
                            arrowScores[endNum - 1][2] = "0"
                            //Set textfield border when not selected
                            cell.arrow1Field.layer.borderWidth = 0.0
                            endNum -= 1
                            endArrowNum = currRound.arrowsPerEnd - 1
                        }
                    } else if endArrowNum == 1 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow2Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    } else if endArrowNum == 2 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow3Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    }
                } else {
                    let cell = tableView.cellForRow(at: indexPath) as! sixArrowEndCell
                    //Reset current cell to look like the next cell
                    if endArrowNum == 0 {
                        if endNum == 0 {
                            //do nothing
                        } else {
                            arrowScores[endNum - 1][2] = "0"
                            //Set textfield border when not selected
                            cell.arrow1Field.layer.borderWidth = 0.0
                            endNum -= 1
                            endArrowNum = currRound.arrowsPerEnd - 1
                        }
                    } else if endArrowNum == 1 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow2Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    } else if endArrowNum == 2 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow3Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    } else if endArrowNum == 3 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow4Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    } else if endArrowNum == 4 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow5Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    } else if endArrowNum == 5 {
                        arrowScores[endNum][endArrowNum - 1] = "0"
                        //Set textfield border when selected
                        cell.arrow6Field.layer.borderWidth = 0.0
                        endArrowNum -= 1
                    }
                }
            }
            
            if endNum == currRound.endCount {
                endNum = currRound.endCount - 1
                endArrowNum = currRound.arrowsPerEnd - 1
                arrowScores[endNum][endArrowNum] = "0"
                targetImageView.gestureRecognizers?.first!.isEnabled = true
            }
            //Get previous cell
            let prevIndexPath = IndexPath(row: endNum, section: 0)
            tableView.scrollToRow(at: prevIndexPath, at: .middle, animated: true)
            
            if currRound.arrowsPerEnd == 3 {
                let prevCell = tableView.cellForRow(at: prevIndexPath) as! threeArrowEndCell
                
                //Reset colors and text in previous cell
                if endArrowNum == 0 {
                    prevCell.arrow1Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow1Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow1Field.layer.borderWidth = 2.0
                    prevCell.arrow1Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 1 {
                    prevCell.arrow2Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow2Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow2Field.layer.borderWidth = 2.0
                    prevCell.arrow2Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 2 {
                    prevCell.arrow3Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow3Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow3Field.layer.borderWidth = 2.0
                    prevCell.arrow3Field.layer.borderColor = UIColor.black.cgColor
                    //Reset row colors
                    prevCell.cellView.backgroundColor = UIColor.white
                    prevCell.endLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    prevCell.totalLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                }
                
                //Calculate new end total after removing arrow
                let endTot = calculateEndTotal(arrows: arrowScores[endNum])
                if endTot == 0 { prevCell.totalLabel.text = "" }
                else { prevCell.totalLabel.text = String(endTot) }
            } else {
                let prevCell = tableView.cellForRow(at: prevIndexPath) as! sixArrowEndCell
                
                //Reset colors and text in previous cell
                if endArrowNum == 0 {
                    prevCell.arrow1Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow1Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow1Field.layer.borderWidth = 2.0
                    prevCell.arrow1Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 1 {
                    prevCell.arrow2Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow2Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow2Field.layer.borderWidth = 2.0
                    prevCell.arrow2Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 2 {
                    prevCell.arrow3Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow3Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow3Field.layer.borderWidth = 2.0
                    prevCell.arrow3Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 3 {
                    prevCell.arrow4Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow4Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow4Field.layer.borderWidth = 2.0
                    prevCell.arrow4Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 4 {
                    prevCell.arrow5Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow5Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow5Field.layer.borderWidth = 2.0
                    prevCell.arrow5Field.layer.borderColor = UIColor.black.cgColor
                } else if endArrowNum == 5 {
                    prevCell.arrow6Field.text = ""
                    //Get rid of color corresponding to previous arrow score
                    prevCell.arrow6Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    //Set border on cell again
                    prevCell.arrow6Field.layer.borderWidth = 2.0
                    prevCell.arrow6Field.layer.borderColor = UIColor.black.cgColor
                    //Reset row colors
                    prevCell.cellView.backgroundColor = UIColor.white
                    prevCell.endLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                    prevCell.totalLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                }
                
                //Calculate new end total after removing arrow
                let endTot = calculateEndTotal(arrows: arrowScores[endNum])
                if endTot == 0 { prevCell.totalLabel.text = "" }
                else { prevCell.totalLabel.text = String(endTot) }
            }
            
//            if targets.count > 0 { targetImageView.image = targets.last }
//            else { targetImageView.image = UIImage(named: currRound.targetFace)}
        }
        let prevIndexPath = IndexPath(row: endNum, section: 0)
        tableView.scrollToRow(at: prevIndexPath, at: .middle, animated: true)
    }
    
    @IBAction func finishTapped(_ sender: UIButton) {
        stopTimer()
        animateIn()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        animateIn()
    }
    
}

