//
//  counterScreen.swift
//  RiseArchery
//
//  Created by Campbell Affleck on 6/22/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit
import RealmSwift

class counterScreen: UIViewController {

    //MARK: Properties
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var constainingView: UIView!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var distanceControl: UISegmentedControl!
    
    //MARK: Variables
    var count = 0
    var scoringType = "counter"
    var date = ""
    var distance = "18m"
    let defaults = UserDefaults.standard
    weak var timer: Timer?
    var startTime: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        buttonSetUp()
        finishButton.layer.cornerRadius = 10
        cancelButton.layer.cornerRadius = 10
        countLabel.text = String(count)
        
        dimView.isHidden = true
        dimView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(self.dismissEffect), name: NSNotification.Name(rawValue: "dismissDimView"), object: nil)
        
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
        animateOut()
    }
    
    func buttonSetUp() {
        let buttons = [plusButton, minusButton]
        for b in buttons {
            b?.layer.cornerRadius = 0.5 * (b?.bounds.size.width)!
            b?.imageEdgeInsets = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
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
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "counterCancelSegue" {
            let vc = segue.destination as? cancelScoring
            vc?.scoringType   = scoringType
        } else if segue.identifier == "saveCounterSegue" {
            let vc = segue.destination as? saveCounter
            vc?.count = count
            vc?.date = date
            vc?.time = timerLabel.text ?? "00:00"
            vc?.distance = distance
        }
    }
    
    //MARK: Actions
    @IBAction func cancelTapped(_ sender: UIButton) {
        animateIn()
    }
    @IBAction func finishTapped(_ sender: UIButton) {
        stopTimer()
        animateIn()
    }
    @IBAction func minusTapped(_ sender: UIButton) {
        if count != 0 {
            count -= 1
            countLabel.text = String(count)
        }
    }
    @IBAction func plusTapped(_ sender: UIButton) {
        count += 1
        countLabel.text = String(count)
    }
    @IBAction func distanceChanged(_ sender: UISegmentedControl) {
        var dist1 = "18m"
        var dist2 = "50m"
        var dist3 = "70m"
        if defaults.value(forKey: "DistanceUnit") as! String != "Metric (meters)" {
            dist1 = "20yd"
            dist2 = "60yd"
            dist3 = "80yd"
        }
        let index = sender.selectedSegmentIndex
        if index      == 0 { distance = dist1 }
        else if index == 1 { distance = dist2 }
        else if index == 2 { distance = dist3 }
    }
    
    
}
