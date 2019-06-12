//
//  targetScoring.swift
//  HitArcheryScoring
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
    var roundName = ""
    var totalScore = 0
    var targets = [UIImage]()
    var arrows = [Int]()
    var arrowLocations = [CGPoint]()
    var arrowScores: [[String]] = []    //The arrow scores are saved here as an array of strings for each end.
    var hits = 0
    var endNum = 0
    var endArrowNum = 0
    var endCells: [threeArrowEndCell] = []
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var date = ""
    let scoringType = "target"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pop up background dimming stuff
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        getRoundInfo()
        roundName = headerTitle
        headerTitle += " #" + String(currRound.roundNum)  //Set header title with number
        //Put cells in array so they aren't reused when the tableview scrolls
        for x in 1...10 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "endCellID") as! threeArrowEndCell
            cell.endLabel.text = String(x)
            cell.inputType = scoringType
            cell.setUp()
            cell.delegate = self
            endCells.append(cell)
        }
        
        setUpTableView()
        tableView.isUserInteractionEnabled = false
        targetImageView.image = UIImage(named: "Vertical3Spot")
        targetScrollView.delegate = self
        setZoomScale()
        updateImageConstraints()
        
        //Set up arrowScores array so that the values can be updated as arrow scores are recorded
        for _ in 0...9 {
            arrowScores.append(["0", "0", "0"])
        }
        
        //Configure aesthetics for table/buttons
        tableView.separatorStyle = .none     //Gets rid of separator line between table cells
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        removeLastButton.layer.cornerRadius = 10
        titleLabel.text = headerTitle
        
        //Set textfield border of first arrow field
        let indexPath = IndexPath(row: endNum, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! threeArrowEndCell
        cell.arrow1Field.layer.borderWidth = 2.0
        cell.arrow1Field.layer.borderColor = UIColor.black.cgColor
        
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
    //Determine which scoring round is being scored
    func getRoundInfo() {
        for result in realm.objects(ScoringRound.self) {
            if result.roundName == headerTitle {
                currRound = result
            }
        }
    }
    
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
        let cell = endCells[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //Deals with delegate from the custom table cell
    func textFieldShouldEndEditing(end: Int, arrow: Int, score: String, cell: threeArrowEndCell) {
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
        targets.append(newTarget)
        arrowLocations.append(point)
        targetImageView.image = newTarget
        
        print(point)
        var calculatedScore = calculateScore(targetType: "Vertical3Spot", point: point, innerTen: false)
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
    func calculateScore(targetType : String, point : CGPoint, innerTen : Bool) -> [String] {
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
            if innerTen {
                if distFromCenter < 22.5 { score = 10 }
                else if distFromCenter > 22.5 && distFromCenter < 90 { score = 9 }
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
            if innerTen {
                if distFromCenter < 14.5 { score = 10 }
                else if distFromCenter > 14.5 && distFromCenter < 58 { score = 9 }
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
        let cell = tableView.cellForRow(at: indexPath) as! threeArrowEndCell
        //Calculate new end total after each arrow
        let endTot = calculateEndTotal(ar1: arrowScores[endNum][0], ar2: arrowScores[endNum][1], ar3: arrowScores[endNum][2])
        cell.totalLabel.text = String(endTot)
        if endArrowNum == 0 {
            cell.arrow1Field.text = score
            applyEndColors(cell: cell, score: score)
            endArrowNum += 1
        } else if endArrowNum == 1 {
            cell.arrow2Field.text = score
            applyEndColors(cell: cell, score: score)
            endArrowNum += 1
        } else {
            cell.arrow3Field.text = score
            applyEndColors(cell: cell, score: score)
            endArrowNum = 0
            endNum += 1
            if endNum == 10 {
                targetImageView.gestureRecognizers?.first!.isEnabled = false
            } else {
                let nextIndexPath = IndexPath(row: endNum, section: 0)
                tableView.scrollToRow(at: nextIndexPath, at: .middle, animated: true)
                let nextCell = tableView.cellForRow(at: nextIndexPath) as! threeArrowEndCell
                nextCell.arrow1Field.layer.borderWidth = 2.0
                nextCell.arrow1Field.layer.borderColor = UIColor.black.cgColor
            }
        }
    }
    
    func calculateEndTotal(ar1 : String, ar2 : String, ar3 : String) -> Int {
        let arrows = [ar1, ar2, ar3]
        var total = 0
        for a in arrows {
            if a == "X" { total += 10}
            else if a == "M" { total += 0}
            else { total += Int(a) ?? 0}
        }
        return total
    }
    
    //Apply background color to field score was just put in, and move "active field" border to next field
    func applyEndColors(cell : threeArrowEndCell, score : String) {
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
        } else {
            cell.arrow3Field.backgroundColor = determineEndColor(score: score)
            cell.arrow3Field.layer.borderWidth = 0.0
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
            vc?.endCount = currRound.endCount
            vc?.roundNum = currRound.roundNum
            vc?.headerTitle = headerTitle
            vc?.timerValue = timerLabel.text!
            vc?.startDate = date
            vc?.scoringType = scoringType
            vc?.targetFace = currRound.targetFace
            vc?.aLocations = arrowLocations
            vc?.targetImage = targets.last ?? UIImage(named: currRound.targetFace)!
            vc?.roundName = roundName
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
        if !targets.isEmpty {
            //Set target image to last image without most recent arrow mark
            targetImageView.image = targets.last
            targets.removeLast()
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
            
            if endNum != 10 {
                //Get current cell
                let indexPath = IndexPath(row: endNum, section: 0)
                tableView.scrollToRow(at: indexPath, at: .middle, animated: true)
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
                        endArrowNum = 2
                    }
                } else if endArrowNum == 1 {
                    arrowScores[endNum][0] = "0"
                    //Set textfield border when selected
                    cell.arrow2Field.layer.borderWidth = 0.0
                    endArrowNum = 0
                } else {
                    arrowScores[endNum][1] = "0"
                    //Set textfield border when selected
                    cell.arrow3Field.layer.borderWidth = 0.0
                    endArrowNum = 1
                }
            }
            
            if endNum == 10 {
                endNum = 9
                endArrowNum = 2
                arrowScores[9][2] = "0"
                targetImageView.gestureRecognizers?.first!.isEnabled = true
            }
            //Get previous cell
            let prevIndexPath = IndexPath(row: endNum, section: 0)
            tableView.scrollToRow(at: prevIndexPath, at: .middle, animated: true)
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
            } else {
                prevCell.arrow3Field.text = ""
                //Get rid of color corresponding to previous arrow score
                prevCell.arrow3Field.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                prevCell.cellView.backgroundColor = UIColor.white
                prevCell.endLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                prevCell.totalLabel.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1.0)
                //Set border on cell again
                prevCell.arrow3Field.layer.borderWidth = 2.0
                prevCell.arrow3Field.layer.borderColor = UIColor.black.cgColor
            }
            
            //Calculate new end total after removing arrow
            let endTot = calculateEndTotal(ar1: arrowScores[endNum][0], ar2: arrowScores[endNum][1], ar3: arrowScores[endNum][2])
            if endTot == 0 { prevCell.totalLabel.text = "" }
            else { prevCell.totalLabel.text = String(endTot) }
            
            if targets.count > 0 { targetImageView.image = targets.last }
            else { targetImageView.image = UIImage(named: currRound.targetFace)}
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

