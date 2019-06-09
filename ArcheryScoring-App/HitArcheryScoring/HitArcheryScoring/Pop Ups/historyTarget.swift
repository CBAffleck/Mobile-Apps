//
//  historyTarget.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/9/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import UIKit

class historyTarget: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate  {

    //MARK: Properties
    @IBOutlet weak var popUpView: UIView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var runLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var totalScoreLabel: UILabel!
    @IBOutlet weak var hitsLabel: UILabel!
    
    
    //MARK: Variables
    var ends: [ScoringEndData] = []
    var endTots: [Int] = []
    //HistoryRound variables
    var roundTitle: String = ""
    var time : String = ""
    var date : String = ""
    var arrowScores : [[String]] = [[""]]
    var arrowLocations : [CGPoint]?
    var runningScores : [Int] = []
    var totalScore : Int = 0
    var hits : Int = 0
    var relativePR : Int = 0
    var scoringType : String = ""
    var targetFace : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcEndTots()
        createEndArray()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        setUpTableView()
//        drawArrowPoints()

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 20
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        closeButton.layer.cornerRadius = 10
        tableView.isUserInteractionEnabled = false
        
        titleLabel.text = roundTitle
        dateLabel.text = date
        timeLabel.text = "Time: " + time
        print(time)
        totalScoreLabel.text = "Score: " + String(totalScore)
        hitsLabel.text = "Hits: " + String(hits)
        
    }
    
    func createEndArray() {
        for x in 0...9 {
            let endData = ScoringEndData(a1Score: arrowScores[x][0], a2Score: arrowScores[x][1], a3Score: arrowScores[x][2], endTot: String(endTots[x]), runNum: String(runningScores[x]))
            ends.append(endData)
        }
    }
    
    func calcEndTots() {
        for end in arrowScores {
            var endTot = 0
            for a in end {
                if a == "X" {
                    endTot += 10
                }
                else if a == "M" { endTot += 0}
                else {
                    endTot += Int(a) ?? 0
                }
            }
            endTots.append(endTot)
        }
    }
    
    //TableView set up and management
    func setUpTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return endTots.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let end = ends[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "congratsEndCell") as! congratsEndCell
        cell.endLabel.text = "\(indexPath.row + 1)"
        cell.setInfo(end: end)
        return cell
    }
    
//    func drawArrowPoints() {
//        var targetImage = UIImage(named: "SingleSpot")
//        for point in arrowLocations! {
//            let newTarget = drawImage(image: UIImage(named: "ArrowMarkGreen")!, inImage: imageView.image!, atPoint: point)
//            targetImage = newTarget
//        }
//        imageView.image = targetImage
//    }
    
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

    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
