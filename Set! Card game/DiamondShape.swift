//
//  Diamond.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 06.10.2023.
//

import SwiftUI

struct DiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        // Define the points of the diamond shape
        let topPoint = CGPoint(x: rect.midX, y: rect.minY)
        let bottomPoint = CGPoint(x: rect.midX, y: rect.maxY)
        let leftPoint = CGPoint(x: rect.minX, y: rect.midY)
        let rightPoint = CGPoint(x: rect.maxX, y: rect.midY)
        
        // Move to the top point of the diamond
        path.move(to: topPoint)
        
        // Draw lines to the other points to complete the diamond
        path.addLine(to: rightPoint)
        path.addLine(to: bottomPoint)
        path.addLine(to: leftPoint)
        path.addLine(to: topPoint)
        
        return path
    }
}

