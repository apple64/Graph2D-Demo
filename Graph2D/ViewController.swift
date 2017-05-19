//
//  ViewController.swift
//  Graph2D
//
//  Created by Γιώργος Χαλκιαδούδης on 17/5/17.
//  Copyright © 2017 George Chalkiadoudis. All rights reserved.
//

import UIKit
import Graph2DFramework

class ViewController: UIViewController, Graph2DDelegate {
    
    @IBOutlet weak var graph: graph2D!
    
    private var testPoints = [pointForGraph.init(fromX: 0, fromY: 0),
                              pointForGraph.init(fromX: 30, fromY: 10),
                              pointForGraph.init(fromX: 35, fromY: 30),
                              pointForGraph.init(fromX: 70, fromY: 40),
                              pointForGraph.init(fromX: 100, fromY: 110)]
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        graph.delegate = self
        graph.graphPoints = testPoints
    }
    
    // MARK: - IBActions

    @IBAction func increaseXValuesBy(_ sender: Any) {
        var newTestPoints = [pointForGraph]()
        
        for point in testPoints {
            newTestPoints.append(pointForGraph.init(fromX: point.x + 1, fromY: point.y))
        }
        
        testPoints = newTestPoints
        
        graph.graphPoints = testPoints
    }
    
    @IBAction func increaseYValuesBy(_ sender: Any) {
        var newTestPoints = [pointForGraph]()
        
        for point in testPoints {
            newTestPoints.append(pointForGraph.init(fromX: point.x, fromY: point.y + 1))
        }
        
        testPoints = newTestPoints
        
        graph.graphPoints = testPoints
    }

    @IBAction func decreaseXValuesBy(_ sender: Any) {
        var newTestPoints = [pointForGraph]()
        
        for point in testPoints {
            newTestPoints.append(pointForGraph.init(fromX: point.x - 1, fromY: point.y))
        }
        
        testPoints = newTestPoints
        
        graph.graphPoints = testPoints
    }
    
    @IBAction func decreaseYValuesBy(_ sender: Any) {
        var newTestPoints = [pointForGraph]()
        
        for point in testPoints {
            newTestPoints.append(pointForGraph.init(fromX: point.x, fromY: point.y - 1))
        }
        
        testPoints = newTestPoints
        
        graph.graphPoints = testPoints
    }
    
    @IBAction func clearData(_ sender: Any) {
        testPoints.removeAll()
        
        graph.graphPoints = testPoints
    }
    
    @IBAction func loadExampleData(_ sender: Any) {
        testPoints = [pointForGraph.init(fromX: 0, fromY: 0),
                      pointForGraph.init(fromX: 30, fromY: 10),
                      pointForGraph.init(fromX: 35, fromY: 30),
                      pointForGraph.init(fromX: 70, fromY: 40),
                      pointForGraph.init(fromX: 100, fromY: 90)]
        
        graph.graphPoints = testPoints
    }
    
    // MARK: - Delegate
    
    func circlePointSelectedOnGraph(indexSelectedName: String) {
        graph.dotToHighlight = Int(indexSelectedName)
    }
}
