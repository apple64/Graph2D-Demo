//
//  CircleForGraph.swift
//  Graph2D
//
//  Created by Γιώργος Χαλκιαδούδης on 17/5/17.
//  Copyright © 2017 George Chalkiadoudis. All rights reserved.
//

import Foundation

public struct circleForGraph {
    let center: pointForGraph
    let diameter: Double
    let fill: Bool
    
    public init(center: pointForGraph, diameter: Double, fill: Bool) {
        self.center = center
        self.diameter = diameter
        self.fill = fill
    }
}
