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
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var contentView: UIView!
    
    
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
    var scrollViewHeight = CGFloat(0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calcEndTots()
        createEndArray()
        tableView.separatorStyle = .none
        tableView.alwaysBounceVertical = false
        setUpTableView()
        addTargetImage()

        // Do any additional setup after loading the view.
        popUpView.layer.cornerRadius = 20
        scrollView.layer.cornerRadius = 20
        contentView.layer.cornerRadius = 20
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
    
    func addTargetImage() {
        var contentHeight = tableView.frame.height + titleLabel.frame.height + dateLabel.frame.height + endLabel.frame.height
        var targetImage = UIImageView.init(image: UIImage(named: "NoArrowScores"))
        if scoringType == "target" {
            targetImage = UIImageView.init(image: loadImageFromDiskWith(fileName: targetFace + String(roundTitle.prefix(3)) + String(roundTitle.components(separatedBy: "#")[1])))
        }
        contentView.addSubview(targetImage)
        targetImage.translatesAutoresizingMaskIntoConstraints = false
        targetImage.topAnchor.constraint(equalTo: tableView.bottomAnchor, constant: -20).isActive = true
        targetImage.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        targetImage.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        targetImage.heightAnchor.constraint(equalToConstant: tableView.frame.width).isActive = true
        targetImage.widthAnchor.constraint(equalToConstant: tableView.frame.width).isActive = true
        targetImage.contentMode = .scaleAspectFit
        contentHeight += tableView.frame.width
        
        if contentHeight > scrollView.frame.height {
            scrollViewHeight = contentHeight
            }
    }
    
    func loadImageFromDiskWith(fileName : String) -> UIImage {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(fileName)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image ?? UIImage(named: "SingleSpot")!
        }
        return UIImage(named: "SingleSpot")!
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollView.contentOffset.x = 0
    }
    
    override func viewDidLayoutSubviews() {
        scrollView.delegate = self
        if scrollViewHeight != CGFloat(0) {
            scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: scrollViewHeight)
        }
    }

    //MARK: Actions
    @IBAction func closeTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
}
