//
//  Graph2D.swift
//  Graph2D
//
//  Created by Γιώργος Χαλκιαδούδης on 17/5/17.
//  Copyright © 2017 George Chalkiadoudis. All rights reserved.
//

import UIKit

public class graph2D: UIView {

    // The array with input values
    public var graphPoints = [pointForGraph]() {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override public var bounds: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }
    
    public var delegate:Graph2DDelegate?
    
    // Labels (Three at the top and three at the bottom)
    @IBInspectable public var lineWidth: Double = 1
    @IBInspectable public var dotDiameter: Double = 2
    @IBInspectable public var topLeftLabel: String?
    @IBInspectable public var topLabel: String?
    @IBInspectable public var topRightLabel: String?
    @IBInspectable public var bottomLeftLabel: String?
    @IBInspectable public var bottomLabel: String?
    @IBInspectable public var bottomRightLabel: String?
    
    // Target label and its value
    @IBInspectable public var targetLabel: String = "Target"
    @IBInspectable public var targetValue: Double = 100

    // Offset to keep the values clearly visible
    @IBInspectable public var xAxisOffsetPercentage: Double = 0.95
    
    @IBInspectable public var labelFontSize: CGFloat = 15
    public var labelFont: UIFont = UIFont.systemFont(ofSize: 15)
    
    // Line and dot colors
    @IBInspectable public var lineColor: UIColor = .white
    @IBInspectable public var dotColor: UIColor = .white
    
    // Label properies
    @IBInspectable public var labelWidth = 150.0
    @IBInspectable public var labelHeight = 23.0
    public let labelSpaceToEdge: Double = 8
    
    public var dotToHighlight: Int? {
        didSet {
            highlightDot(dotIndex: dotToHighlight!)
        }
    }
    
    // MARK: - drawRect

    override public func draw(_ rect: CGRect) {
        layer.sublayers?.removeAll()
        
        addGestureRec()
        
        let maxValues = findMaxValues(forPointForGraph: graphPoints)
        let dimensions = (Double(layer.bounds.size.width), Double(layer.bounds.size.height))
        
        if graphPoints.count > 0 {
            for index in 0 ..< graphPoints.count  {
                let point = graphPoints[index]
                
                draw(circle: circleForGraph.init(center: calculatePointInGraph(withPoint: pointForGraph.init(fromX: point.x, fromY: point.y),
                                                                               withMaxValues: maxValues,
                                                                               withDimensions: dimensions),
                                                 diameter: dotDiameter,
                                                 fill: true),
                     withName: String(index))
                
                if index < graphPoints.count-1 {
                    let endPoint = graphPoints[index+1]
                    draw(lineFromPoint: calculatePointInGraph(withPoint: point,
                                                              withMaxValues: maxValues,
                                                              withDimensions: dimensions),
                         toPoint: calculatePointInGraph(withPoint: endPoint,
                                                        withMaxValues: maxValues,
                                                        withDimensions: dimensions),
                         dashPattern:nil)
                }
            }
            
            draw(lineFromPoint: calculatePointInGraph(withPoint: pointForGraph.init(fromX: 0, fromY: targetValue),
                                                      withMaxValues: maxValues,
                                                      withDimensions: dimensions),
                 toPoint: calculatePointInGraph(withPoint: pointForGraph.init(fromX: maxValues.x!, fromY: targetValue),
                                                withMaxValues: maxValues,
                                                withDimensions: dimensions),
                 dashPattern:[4,5])

            
            addLabelsToGraph()
        } else {
            addNoDataLabelToGraph()
        }
    }

    // MARK: - Draw Lines and Circles
    
    private func draw(lineFromPoint start: pointForGraph, toPoint end: pointForGraph, dashPattern: [NSNumber]?) {
        let lineLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        // For target line only
        if let lineDashPattern = dashPattern {
            lineLayer.lineDashPattern = lineDashPattern
            
            addLabelToGraph(withFrame: CGRect(x: start.x + labelSpaceToEdge, y: start.y - labelHeight - labelSpaceToEdge, width: labelWidth, height: labelHeight),
                            position: .left,
                            text: targetLabel)
        }

        lineLayer.strokeColor = lineColor.cgColor
        lineLayer.fillColor = lineColor.cgColor
        
        path.move(to: CGPoint(x: start.x, y: start.y))
        path.addLine(to: CGPoint(x: end.x, y: end.y))
        
        lineLayer.path = path
        
        layer.addSublayer(lineLayer)
    }
    
    private func draw(circle: circleForGraph, withName name: String) {
        let circleLayer = CAShapeLayer()
        let path = CGMutablePath()
        
        circleLayer.strokeColor = dotColor.cgColor
        circleLayer.fillColor = dotColor.cgColor
        circleLayer.name = name
        
        let radius = circle.diameter / 2
        path.addEllipse(in: CGRect(x: circle.center.x - radius, y: circle.center.y - radius, width: circle.diameter, height: circle.diameter))
        
        circleLayer.path = path
        
        let animationLineWidth = circleAnimationLineWidth()
        circleLayer.add(animationLineWidth, forKey: animationLineWidth.keyPath)
        let animationFillColor = circleAnimationFillColor()
        circleLayer.add(animationFillColor, forKey: animationFillColor.keyPath)

        layer.addSublayer(circleLayer)
    }
    
    private func addGestureRec() {
        for recognizer in gestureRecognizers ?? [] {
            removeGestureRecognizer(recognizer)
        }
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(valueSelected(recognizer:)))
        addGestureRecognizer(gestureRecognizer)
    }
    
    // MARK: - Draw Labels
    
    private func addLabelsToGraph() {
        addLabelToGraph(withFrame: CGRect(x: labelSpaceToEdge, y: 0, width: labelWidth, height: labelHeight),
                         position: .left,
                         text: topLeftLabel)
        addLabelToGraph(withFrame: CGRect(x: Double(layer.bounds.size.width) / 2 - labelWidth / 2, y: 0, width: labelWidth, height: labelHeight),
                         position: .center,
                         text: topLabel)
        addLabelToGraph(withFrame: CGRect(x: Double(layer.bounds.size.width) - labelWidth - labelSpaceToEdge, y: 0, width: labelWidth, height: labelHeight),
                         position: .right,
                         text: topRightLabel)
        addLabelToGraph(withFrame: CGRect(x: labelSpaceToEdge, y: Double(layer.bounds.size.height) - labelSpaceToEdge - labelHeight, width: labelWidth, height: labelHeight),
                         position: .left,
                         text: bottomLeftLabel)
        addLabelToGraph(withFrame: CGRect(x: Double(layer.bounds.size.width) / 2 - labelWidth / 2, y: Double(layer.bounds.size.height) - labelSpaceToEdge - labelHeight, width: labelWidth, height: labelHeight),
                         position: .center,
                         text: bottomLabel)
        addLabelToGraph(withFrame: CGRect(x: Double(layer.bounds.size.width) - labelWidth - labelSpaceToEdge, y: Double(layer.bounds.size.height) - labelSpaceToEdge - labelHeight, width: labelWidth, height: labelHeight),
                         position: .right,
                         text: bottomRightLabel)
    }
    
    private func addLabelToGraph(withFrame frame: CGRect, position: NSTextAlignment, text: String?) {
        let label: UILabel = UILabel.init(frame: frame)
        label.textColor = lineColor
        label.backgroundColor = .clear
        label.font = labelFont
        label.font.withSize(labelFontSize)
        label.textAlignment = position
        if let labelString = text {
            label.text = labelString
        }
        
        addSubview(label)
    }
    
    private func addNoDataLabelToGraph() {
        addLabelToGraph(withFrame: CGRect(x: Double(layer.bounds.size.width) / 2 - labelWidth / 2, y: Double(layer.bounds.size.height) / 2 - labelWidth / 2, width: labelWidth, height: labelHeight),
                        position: .center,
                        text: "No Data")
    }
    
    // MARK: - Calculations
    
    private func calculatePointInGraph(withPoint point: pointForGraph, withMaxValues maxValues: (x: Double?, y: Double?), withDimensions dimensions: (x: Double, y: Double)) -> pointForGraph {
        let fixedDimensions = (x: dimensions.x, y: dimensions.y - (labelHeight * 2 + 30))
        
        return pointForGraph.init(fromX: (point.x / maxValues.x!) * (dimensions.x * xAxisOffsetPercentage) + (dimensions.x * (1 - xAxisOffsetPercentage)) / 2,
                                  fromY: reverseYAxisQuadrant(forValue: ((point.y / maxValues.y!) * fixedDimensions.y + (dimensions.y - fixedDimensions.y) / 2),
                                                              usingDimensionHeight: dimensions.y,
                                                              withYMaxValue: maxValues.y!)
        )
    }
    
    private func reverseYAxisQuadrant(forValue value: Double, usingDimensionHeight height: Double, withYMaxValue maxYValue: Double) -> Double {
        if targetValue < maxYValue {
            return height - value * (targetValue / maxYValue)
        } else {
            return height - value * 0.8
        }
    }
    
    private func findMaxValues(forPointForGraph table: [pointForGraph]) -> (x: Double?, y: Double?) {
        if table.count > 0 {
            var maxValues = (x: table.first?.x, y: table.first?.y)
            
            for point in table {
                if point.x > maxValues.x! {
                    maxValues.x = point.x
                }
                if point.y > maxValues.y! {
                    maxValues.y = point.y
                }
            }
            
            return maxValues
        } else {
            return (nil, nil)
        }
    }
    
    // MARK: - Other
    
    private func highlightDot(dotIndex: Int) {
        clearSublayoutInIndex(index: dotIndex)
        
        let maxValues = findMaxValues(forPointForGraph: graphPoints)
        let dimensions = (Double(layer.bounds.size.width), Double(layer.bounds.size.height))
        
        draw(circle: circleForGraph.init(center: calculatePointInGraph(withPoint: graphPoints[dotIndex],
                                                                       withMaxValues: maxValues,
                                                                       withDimensions: dimensions),
                                         diameter: dotDiameter,
                                         fill: true),
             withName: String(dotIndex))
    }
    
    private func clearSublayoutInIndex(index: Int) {
        for sublayer in layer.sublayers! {
            if let sublayerName = sublayer.name {
                if sublayer.isKind(of: CAShapeLayer.self) && sublayerName == String(index) {
                    print(sublayer.name!)
                    sublayer.removeFromSuperlayer()
                }
            }
        }
    }
    
    // MARK: -  Tap Gesture Recognizer
    
    func valueSelected(recognizer: UITapGestureRecognizer) {
        let locationTapped: CGPoint = recognizer.location(in: self)
        
        for sublayer in layer.sublayers! {
            if sublayer.isKind(of: CAShapeLayer.self) && sublayer.name != nil {
                let circleLayer = sublayer as? CAShapeLayer
                
                if let circleTapped = circleLayer?.path?.contains(locationTapped) {
                    if circleTapped {
                        delegate?.circlePointSelectedOnGraph(indexSelectedName: (circleLayer?.name)!)
                    }
                }
            }
        }
    }
    
    // MARK: - ANimations
    
    private func circleAnimationLineWidth() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "lineWidth")
        animation.fromValue = dotDiameter
        animation.toValue = dotDiameter * 2
        animation.duration = 1.0
        animation.repeatCount = 1
        animation.autoreverses = true
        
        return animation
    }
    
    private func circleAnimationFillColor() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "fillColor")
        animation.fromValue = UIColor.red.cgColor
        animation.toValue = dotColor.cgColor
        animation.duration = 1.0
        animation.repeatCount = 1
        animation.autoreverses = true
        
        return animation
    }
}
