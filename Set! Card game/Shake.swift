//
//  Shake.swift
//  Set! Card game
//
//  Created by https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/
//

import SwiftUI

struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat {
        get {movement}
        // works only in one direction
        set { if newValue < movement {
            movement = newValue
        }
        }
    }
    var movement: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
//        print("animate!    \(movement)")
        return ProjectionTransform(CGAffineTransform(translationX:
                                                        amount * sin(movement * .pi * CGFloat(shakesPerUnit)),
                                                     y: 0))
    }
}
