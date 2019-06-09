//
//  Model.swift
//  BuildingCustomViewsSwiftUI
//
//  Created by Claire Murphy on 6/8/19.
//  Copyright © 2019 Claire Murphy. All rights reserved.
//

import Foundation
import SwiftUI

class Ring {
    
    struct Wedge: Equatable {
        var startAngle: Angle
        // where 1.0 = a whole circle
        var width: Double
        // also a percentage, of the available depth
        var depth: Double
        var hue: Double
        
    }
    
    var wedges: [Int: Wedge]
    var wedgeIDs: [Int]
    
    init(wedges: [Int: Wedge]) {
        self.wedges = wedges
        wedgeIDs = Array(wedges.keys)
    }
    
    // wedge management
    
    func addWedge() {
        guard let lastID = wedgeIDs.last else {
            wedgeIDs = [0]
            wedges[0] = Wedge(startAngle: Angle(degrees: 360 * Double.random(in: 0..<1)),
                              width: Double.random(in: 0..<1),
                              depth: Double.random(in: 0..<1),
                              hue: Double.random(in: 0..<1))
            return
        }
        let newID = lastID + 1
        let previous = wedges[lastID]!
        let newAngle = previous.startAngle + Angle(degrees: 360 * Double.random(in: 0..<1))
        let newWidth = Double.random(in: 0..<1)

        wedges[newID] = Wedge(startAngle: newAngle, width: newWidth, depth: Double.random(in: 0..<1), hue: Double.random(in:0..<1))
        return
    }
    
    func deleteWedge(with id: Int) {
        wedges.removeValue(forKey: id)
        wedgeIDs.removeAll(where: { $0 == id })
    }
    
}

extension Ring.Wedge: Animatable {
    typealias AnimatableData = AnimatablePair<Double, Double>
    
    var animatableData: AnimatableData {
        get {
            .init(width, depth)
        }
        set {
            width = newValue.first
            depth = newValue.second
        }
    }
    
}
