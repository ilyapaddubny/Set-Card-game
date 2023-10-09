//
//  WaveShape.swift
//  Set! Card game
//
//  Created with https://svg-to-swiftui.quassum.com/
//

import SwiftUI

struct WavedShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.size.width
        let height = rect.size.height
        path.move(to: CGPoint(x: 0.17*width, y: 0.03704*height))
        path.addCurve(to: CGPoint(x: 0.03121*width, y: 0.87963*height), control1: CGPoint(x: -0.018*width, y: 0.04444*height), control2: CGPoint(x: -0.00546*width, y: 0.58333*height))
        path.addCurve(to: CGPoint(x: 0.135*width, y: 0.89815*height), control1: CGPoint(x: 0.09*width, y: 1.01852*height), control2: CGPoint(x: 0.10643*width, y: 0.93636*height))
        path.addCurve(to: CGPoint(x: 0.285*width, y: 0.80556*height), control1: CGPoint(x: 0.225*width, y: 0.77778*height), control2: CGPoint(x: 0.24*width, y: 0.80556*height))
        path.addCurve(to: CGPoint(x: 0.605*width, y: 0.93518*height), control1: CGPoint(x: 0.37044*width, y: 0.80556*height), control2: CGPoint(x: 0.405*width, y: 0.83333*height))
        path.addCurve(to: CGPoint(x: 0.94*width, y: 0.75*height), control1: CGPoint(x: 0.805*width, y: 1.03704*height), control2: CGPoint(x: 0.87*width, y: 0.93518*height))
        path.addCurve(to: CGPoint(x: 0.94*width, y: 0.03704*height), control1: CGPoint(x: 1.01*width, y: 0.56482*height), control2: CGPoint(x: 1.01*width, y: 0.11111*height))
        path.addCurve(to: CGPoint(x: 0.705*width, y: 0.19444*height), control1: CGPoint(x: 0.87*width, y: -0.03704*height), control2: CGPoint(x: 0.815*width, y: 0.18518*height))
        path.addCurve(to: CGPoint(x: 0.17*width, y: 0.03704*height), control1: CGPoint(x: 0.595*width, y: 0.2037*height), control2: CGPoint(x: 0.405*width, y: 0.02778*height))
        path.closeSubpath()
        return path
    }
}
