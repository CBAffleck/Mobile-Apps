//
//  textScoring.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/4/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class textScoring: UIViewController, UITableViewDelegate, UITableViewDataSource, CellDelegate, UITextFieldDelegate {

    //MARK: Properties
    @IBOutlet weak var scoringTable: UITableView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var runningLabel: UILabel!
    @IBOutlet weak var hitLabel: UILabel!
    @IBOutlet weak var tableBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var dimView: UIView!
    
    
    //MARK: Variables
    let realm = try! Realm()
    var currRound = ScoringRound()
    var headerTitle = ""
    var arrowScores: [[String]] = []    //The arrow scores are saved here as an array of strings for each end.
    var totalScore = 0
    var hits = 0
    var rowBeingEdited = 0
    var show_kb = false
    var hide_kb = false
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var date = ""
    let scoringType = "text"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Pop up background dimming stuff
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        
        headerTitle = currRound.roundName + " #" + String(currRound.roundNum)
        setUpTableView()
        self.hideKeyboardOnTap()
        scoringTable.separatorStyle = .none     //Gets rid of separator line between table cells
        scoringTable.showsVerticalScrollIndicator = false
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        titleLabel.text = headerTitle
        //Set up arrowScores array so that the values can be updated as arrow scores are recorded
        for _ in 0...currRound.endCount - 1 {
            arrowScores.append([String](repeating: "0", count: currRound.arrowsPerEnd))
        }
        //Set up and start timer
        startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(resumeTimer), name: NSNotification.Name(rawValue: "NotificationID"), object: nil)
        //Format start date/time into nice string
        let tempDate = Date()
        let dateFormatPrint = DateFormatter()
        dateFormatPrint.dateFormat = "h:mm a, MMM d, yyyy"      //Ex: 4:10 PM, June 8, 2019
        date = dateFormatPrint.string(from: tempDate)
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
    
    //MARK: Keyboard Functions
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Add keyboard observers
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardDidShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func keyboardWillShow(notification: Notification) {
        if show_kb == true {
            if let keyboardHeight = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.height {
                //Sets distance of last cell from bottom of tableview. -100 accounts for pushing the cell too far up with just KB height
                scoringTable.contentInset.bottom = keyboardHeight - 100
                show_kb = false
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if hide_kb == true {
            scoringTable.contentInset.bottom = 0.0
            hide_kb = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: Table Setup
    func setUpTableView() {
        scoringTable.delegate = self
        scoringTable.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currRound.endCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if currRound.arrowsPerEnd == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "endCellID") as! threeArrowEndCell
            cell.endLabel.text = "\(indexPath.row + 1)"
            cell.inputType = scoringType
            cell.setUp()
            cell.delegate = self    //Set delegate to be self so that we can view the textfield data
            return cell
        } else {
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "sixEndCellID") as! sixArrowEndCell
            cell2.endLabel.text = "\(indexPath.row + 1)"
            cell2.inputType = scoringType
            cell2.setUp()
            cell2.delegate = self    //Set delegate to be self so that we can view the textfield data
            return cell2
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    //MARK: Table Cells
    func textFieldShouldEndEditing(end: Int, arrow: Int, score: String) {
        arrowScores[end][arrow] = score
        var calc = calculateTotal()
        totalScore = calc[0]
        hits = calc[1]
        runningLabel.text = "Running Total: " + String(calc[0])
        hitLabel.text = "Hits: " + String(calc[1])
    }
    
    func textFieldBeganEditing(row: Int, showKB: Bool, hideKB: Bool) {
        rowBeingEdited = row
        show_kb = showKB
        hide_kb = hideKB
    }
    
    func calculateTotal() -> [Int] {
        var total = 0
        var hits = 0
        for x in 0...currRound.endCount - 1 {
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "textToFinishSegue" {
            let vc = segue.destination as? finishScoring
            vc?.aScores = arrowScores
            vc?.totalScore = totalScore
            vc?.hits = hits
            vc?.headerTitle = headerTitle
            vc?.timerValue = timerLabel.text!
            vc?.startDate = date
            vc?.scoringType = scoringType
            vc?.currRound = currRound
            vc?.roundNum = currRound.roundNum
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
    
    //MARK: Actions
    @IBAction func finishTapped(_ sender: UIButton) {
        stopTimer()
        animateIn()
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        animateIn()
    }
    
}
