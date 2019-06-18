//
//  ScoresChartView.swift
//  HitArcheryScoring
//
//  Created by Campbell Affleck on 6/16/19.
//  Copyright © 2019 Campbell Affleck. All rights reserved.
//

import Foundation
import Macaw
import RealmSwift

class ScoresChartView: MacawView {
    
    struct ScoreObject {
        var roundNum: String
        var score: Double
    }
    
    static let maxValue = 360               //Max value in graph, 360 because that's the max 70m score
    static let maxValueLineHeight = 150     //Y line height
    static let lineWidth: Double = 240      //X line width
    static let last5Scores = createChartArray()
    
    static let dataDivisor = Double(maxValueLineHeight)/Double(maxValue)
    static let adjustedData: [Double] = last5Scores.map({ $0.score * dataDivisor })
    static var animations: [Animation] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(node: ScoresChartView.createChart(), coder: aDecoder)
        backgroundColor = .clear
    }
    
    private static func createChart() -> Group {
        var items: [Node] = addYAxisItems() + addXAxisItems()
        items.append(createBars())
        
        return Group(contents: items, place: .identity)
    }
    
    //Put together all the y axis items, so the scores
    private static func addYAxisItems() -> [Node] {
        let maxLines = 6
        let lineInterval = Int(maxValue/maxLines)
        let yAxisHeight: Double = 150
        let lineSpacing: Double = 25
        var newNodes: [Node] = []
        
        for i in 1...maxLines {
            let y = yAxisHeight - (Double(i) * lineSpacing)
            let valueLine = Line(x1: -5, y1: y, x2: lineWidth, y2: y).stroke(fill: Color.rgba(r: 24, g: 41, b: 52, a: 0.1), width: 1)
            let valueText = Text(text: "\(i * lineInterval)", align: .max, baseline: .mid, place: .move(dx: -10, dy: y))
            valueText.fill = Color.rgba(r: 24, g: 41, b: 52, a: 1)
            newNodes.append(valueLine)
            newNodes.append(valueText)
        }
        
        let yAxis = Line(x1: 0, y1: 0, x2: 0, y2: yAxisHeight).stroke(fill: Color.rgba(r: 24, g: 41, b: 52, a: 0.25), width: 1)
        newNodes.append(yAxis)
        
        return newNodes
    }
    
    //Put together the x axis items, so the round numbers
    private static func addXAxisItems() -> [Node] {
        let chartBaseY: Double = 150
        var newNodes: [Node] = []
        
        for i in 1...adjustedData.count {
            let x = (Double(i) * 46)
            let valueText = Text(text: last5Scores[i-1].roundNum, align: .max, baseline: .mid, place: .move(dx: x, dy: chartBaseY + 15))
            valueText.fill = Color.rgba(r: 24, g: 41, b: 52, a: 1)
            valueText.font = Font.init(name: "SanFranciscoText", size: 11)
            newNodes.append(valueText)
        }
        
        let xAxis = Line(x1: 0, y1: chartBaseY, x2: lineWidth, y2: chartBaseY).stroke(fill: Color.rgba(r: 24, g: 41, b: 52, a: 0.25), width: 1)
        newNodes.append(xAxis)
        
        return newNodes
    }
    
    //Create bar animations and add them to the animations array
    private static func createBars() -> Group {
        let fill = LinearGradient(degree: 90, from: Color(val: 0x3DA9FC), to: Color(val: 0x3DA9FC).with(a: 0.7))
        let items = adjustedData.map { _ in Group() }
        
        animations = items.enumerated().map { (i: Int, item: Group) in
            item.contentsVar.animation(delay: Double(i) * 0.1) { t in
                let height = adjustedData[i] * t
                let rect = Rect(x: Double(i) * 45 + 15, y: 150 - height, w: 25, h: height)
                return [rect.fill(with: fill)]
            }
        }
        
        return items.group()
    }
    
    static func playAnimations() {
        animations.combine().play()
    }
    
    static func createChartArray() -> [ScoreObject] {
        let realm = try! Realm()
        var scores18m: [HistoryRound] = []
        var scores50m: [HistoryRound] = []
        var scores70m: [HistoryRound] = []
        var last5: [HistoryRound] = []
        
        //Put rounds into arrays arranged by distance
        let rounds = realm.objects(HistoryRound.self)
        for round in rounds {
            if round.distance == "18m" {
                scores18m.append(round)
            } else if round.distance == "50m" {
                scores50m.append(round)
            } else {
                scores70m.append(round)
            }
            last5.append(round)
        }
        
        //Reduce the arrays to include only the most recent rounds scored
        if scores18m.count > 5 { scores18m = Array(scores18m.suffix(5)) }
        if scores50m.count > 5 { scores50m = Array(scores50m.suffix(5)) }
        if scores70m.count > 5 { scores70m = Array(scores70m.suffix(5)) }
        if last5.count > 5 { last5 = Array(last5.suffix(5)) }
    
        //Create scoring objects for 18m rounds
        var scores18mObjects: [ScoreObject] = []
        for r in scores18m {
            let set = ScoreObject(roundNum: String(r.distance) + " #" + String(r.roundNum), score: Double(r.totalScore))
            scores18mObjects.append(set)
        }
        if scores18mObjects.isEmpty { scores18mObjects.append(ScoreObject(roundNum: "18m #1", score: 0)) }
        
        //Create scoring objects for any rounds
        var last5Objects: [ScoreObject] = []
        for r in last5 {
            let set = ScoreObject(roundNum: String(r.distance) + " #" + String(r.roundNum), score: Double(r.totalScore))
            last5Objects.append(set)
        }
        if last5Objects.isEmpty { last5Objects.append(ScoreObject(roundNum: "18m #1", score: 0)) }
        
        return last5Objects
    }
    
    
    
//    private struct ScoreLine {
//        let scores: [CGPoint]
//    }
//
//    //MARK: Variables
//    private var animationRect = Shape(form: Rect())
//
//    private var animations = [Animation]()
//    private var scoreLines = [ScoreLine]()
//    private let cubicCurve = CubicCurveAlgorithm()
//    private let chartHeight = 160
//    private let chartWidth = 240
//    private let captionWidth = 40
//    private let backgroundLineSpacing = 20
//    private let captionsX: [Int] = [1, 2, 3, 4, 5, 6, 7]
//    private let captionsY: [Int] = [360, 300, 240, 180, 120, 60, 0]
//
//    private func createChartArray() {
//        let realm = try! Realm()
//        var scores18m: [Int] = []
//        var scores50m: [Int] = []
//        var scores70m: [Int] = []
//
//        let rounds = realm.objects(HistoryRound.self)
//        for round in rounds {
//            if round.distance == "18m" {
//                scores18m.insert(round.totalScore, at: 0)
//            } else if round.distance == "50m" {
//                scores50m.insert(round.totalScore, at: 0)
//            } else {
//                scores70m.insert(round.totalScore, at: 0)
//            }
//        }
//
//        if scores18m.count > 7 { scores18m = Array(scores18m.prefix(7)) }
//        if scores50m.count > 7 { scores50m = Array(scores50m.prefix(7)) }
//        if scores70m.count > 7 { scores70m = Array(scores70m.prefix(7)) }
//
//        var points18Array: [CGPoint] = []
//        var points50Array: [CGPoint] = []
//        var points70Array: [CGPoint] = []
//        var index = 0.0
//        for score in scores18m {
//            if index == 0.0 {
//                points18Array.append(CGPoint(x: 1.0, y: Double(score)))
//            } else { points18Array.append(CGPoint(x: 40.0*index, y: Double(score))) }
//            index += 1.0
//        }
//        index = 0.0
//        for score in scores50m {
//            if index == 0.0 {
//                points50Array.append(CGPoint(x: 1.0, y: Double(score)))
//            } else { points50Array.append(CGPoint(x: 40.0*index, y: Double(score))) }
//            index += 1.0
//        }
//        index = 0.0
//        for score in scores70m {
//            if index == 0.0 {
//                points70Array.append(CGPoint(x: 1.0, y: Double(score)))
//            } else { points70Array.append(CGPoint(x: 40.0*index, y: Double(score))) }
//            index += 1.0
//        }
//
//        if !points18Array.isEmpty { scoreLines.append(ScoreLine(scores: points18Array)) }
//        else { scoreLines.append(ScoreLine(scores: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)])) }
//
//        if !points50Array.isEmpty { scoreLines.append(ScoreLine(scores: points50Array)) }
//        else { scoreLines.append(ScoreLine(scores: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)])) }
//
//        if !points70Array.isEmpty { scoreLines.append(ScoreLine(scores: points70Array)) }
//        else { scoreLines.append(ScoreLine(scores: [CGPoint(x: 0, y: 0), CGPoint(x: 0, y: 0)])) }
//    }
//
//    private func createScene() {
//        let chartLinesGroup = Group()
//        chartLinesGroup.place = Transform.move(dx: Double(captionWidth), dy: 0)
//        scoreLines.forEach { scoreLine in
//            let dataPoints = scoreLine.scores
//            let controlPoints = self.cubicCurve.controlPointsFromPoints(dataPoints: dataPoints)
//            var path: PathBuilder = MoveTo(x: Double(scoreLine.scores[0].x), y: Double(scoreLine.scores[0].y))
//            for index in 0...dataPoints.count - 2 {
//                path = path.cubicTo(x1: Double(controlPoints[index].controlPoint1.x),
//                                    y1: Double(controlPoints[index].controlPoint1.y),
//                                    x2: Double(controlPoints[index].controlPoint2.x),
//                                    y2: Double(controlPoints[index].controlPoint2.y),
//                                    x: Double(dataPoints[index + 1].x),
//                                    y: Double(dataPoints[index + 1].y))
//            }
//            let shape = Shape(
//                form: path.build(),
//                stroke: Stroke(fill: LinearGradient(degree: 0, from: Color(val: 0x182934), to: Color(val: 0x182934)), width: 2)
//            )
//            chartLinesGroup.contents.append(shape)
//        }
//
//        animationRect = Shape(
//            form: Rect(x: 0, y: 0, w: Double(chartWidth + 1), h: Double(chartHeight + backgroundLineSpacing)),
//            fill: Color(val: 0x182934)
//        )
//        chartLinesGroup.contents.append(animationRect)
//
//        let lineColor = Color.rgba(r: 61, g: 169, b: 252, a: 0.1)
//        let captionColor = Color.rgba(r: 61, g: 169, b: 252, a: 0.5)
//        var captionIndex = 0
//        for index in 0...chartWidth / backgroundLineSpacing {
//            let x = Double(backgroundLineSpacing * index)
//            let y2 = index % 2 == 0 ? Double(chartHeight + backgroundLineSpacing) : Double(chartHeight)
//            chartLinesGroup.contents.append(
//                Line(x1: x, y1: 0, x2: x, y2: y2).stroke(fill: lineColor)
//            )
//            if index % 2 == 0 {
//                let text = Text(
//                    text: String(captionsX[captionIndex]),
//                    font: Font(name: "Serif", size: 14),
//                    fill: captionColor
//                )
//                text.align = .mid
//                text.place = .move(dx: x, dy: y2 + 10)
//                text.opacity = 1
//                chartLinesGroup.contents.append(text)
//                captionIndex += 1
//            }
//        }
//
//        let captionGroup = Group()
//        for index in 0...chartHeight / (backgroundLineSpacing * 2) {
//            let text = Text(
//                text: String(captionsY[index]),
//                font: Font(name: "Serif", size: 14),
//                fill: captionColor
//            )
//            text.place = .move(dx: 0, dy: Double((backgroundLineSpacing * 2) * index))
//            text.opacity = 1
//            captionGroup.contents.append(text)
//        }
//
//        let viewCenterX = Double(self.frame.width / 2)
//        let chartCenterX = viewCenterX - (Double(chartWidth / 2) + Double(captionWidth / 2))
//
//        let chartGroup = [chartLinesGroup, captionGroup].group(place: Transform.move(dx: chartCenterX, dy: 90))
//        self.node = chartGroup
//    }
//
//    private func createAnimations() {
//        animations.removeAll()
//        animations.append(animationRect.placeVar.animation(to: Transform.move(dx: Double(self.frame.width), dy: 0), during: 2))
//    }
//
//    open func play() {
//        createChartArray()
//        createScene()
//        createAnimations()
//        animations.forEach {
//            $0.play()
//        }
//    }
}
