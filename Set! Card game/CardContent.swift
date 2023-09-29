//
//  CardContent.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 28.09.2023.
//

import Foundation

struct CardContent: Equatable {
    static func == (lhs: CardContent, rhs: CardContent) -> Bool {
        return lhs.colorName == rhs.colorName &&
        lhs.opacity == rhs.opacity &&
        lhs.shape == rhs.shape &&
        lhs.numberOfItems == rhs.numberOfItems
    }
    
    let colorName: String
    let opacity: CGFloat
    let shape: ShapeType
    let numberOfItems: Int
    
    init(colorName: String, opacity: CGFloat, shape: ShapeType, numberOfItems: Int) {
        self.colorName = colorName
        self.opacity = opacity
        self.shape = shape
        self.numberOfItems = numberOfItems
    }
    
    enum ShapeType: Equatable {
        case circle(radius: CGFloat)
        case roundedRectangle(cornerRadius: CGFloat)
        case ellipse
        
        var description: String {
            switch self {
            case .circle(let radius): "Shape is a circle with radius - \(radius)"
            case .roundedRectangle(let cornerRadius): "Shape is a roundedRectangle with corner radius - \(cornerRadius)"
            case .ellipse: "Shape is a ellipse"
            }
        }
    }
}
