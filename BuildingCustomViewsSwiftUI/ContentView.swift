//
//  ContentView.swift
//  BuildingCustomViewsSwiftUI
//
//  Created by Claire Murphy on 6/8/19.
//  Copyright © 2019 Claire Murphy. All rights reserved.
//

import Foundation
import SwiftUI

struct ContentView : View {
    var ring: Ring
    
    var body: some View {
        
        ZStack {
            ForEach(ring.wedgeIDs) { id in
                WedgeView(wedge: self.ring.wedges[id]!)
                    .tapAction { withAnimation { self.ring.deleteWedge(with: id) } }
            }
        }
            .padding()
            .tapAction {
                withAnimation {
                    self.ring.addWedge()
                }
        }
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView(ring: Ring(wedges: [
            0: Ring.Wedge(startAngle: Angle(radians: 0), width: 0.3, depth: 0.5, hue: 0),
            1: Ring.Wedge(startAngle: Angle(radians: 1), width: 0.1, depth: 1, hue: 0.1),
            2: Ring.Wedge(startAngle: Angle(radians: 2), width: 0.3, depth: 0.2, hue: 0.5),
            3: Ring.Wedge(startAngle: Angle(radians: 3), width: 0.2, depth: 0.8, hue: 0.9)
            ]))
    }
}
#endif

struct WedgeView: View {
    var wedge: Ring.Wedge
    
    var body: some View {
        WedgeShape(wedge: wedge)
            .fill(AngularGradient(gradient:
                Gradient(colors:
                    [Color(hue: wedge.hue, saturation: 1, brightness: 1),
                    Color(hue: wedge.hue, saturation: 1, brightness: 0.3)]),
                                  center: .center))
    }
}

struct WedgeShape: Shape {
    static func == (lhs: WedgeShape, rhs: WedgeShape) -> Bool {
        lhs.wedge == rhs.wedge
    }
    
    var wedge: Ring.Wedge
    
    func path(in rect: CGRect) -> Path {
        var p = Path()
        let g = WedgeGeometry(wedge, in: rect)

        // inner arc
        p.addArc(center: g.center, radius: g.innerRadius, startAngle: g.startAngle, endAngle: g.endAngle, clockwise: false)
        p.addLine(to: g.endOuter)
        
        // outer ard
        p.addArc(center: g.center, radius: g.outerRadius, startAngle: g.endAngle, endAngle: g.startAngle, clockwise: true)
        p.addLine(to: g.startInner)
        p.closeSubpath()
        
        return p
    }
    
    var animatableData: Ring.Wedge.AnimatableData {
        get {
            return wedge.animatableData
        }
        set {
            wedge.animatableData = newValue
        }
    }
}
