//
//  Cardify.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 26.10.2023.
//

import SwiftUI

struct Cardify: ViewModifier {
    private let base = RoundedRectangle(cornerRadius: Constats.cornerRadius)
    let onTheTable: Bool
    let isChosen: Bool
    let isMatched: Bool
    let oneOfThreeSelected: Bool
    
    var rotation: Double // in degrees
    
    var animatableData: Double {
        get { rotation }
        set { rotation = newValue }
    }
    
    init(onTheTable: Bool, isChosen: Bool, isMatched: Bool, oneOfThreeSelected: Bool) {
        self.onTheTable = onTheTable
        self.isChosen = isChosen
        self.isMatched = isMatched
        self.oneOfThreeSelected = oneOfThreeSelected
        
        rotation = onTheTable ? 0 : 180
    }
    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            if rotation < 90 {
                base
                    .stroke(lineWidth: isChosen ? 5 : 1)
                    .foregroundColor(isChosen ? .blue : .gray)
                base
                    .fill(.white)
                if (isMatched) {
                    base
                        .fill(.green
                            .opacity(oneOfThreeSelected ? 0.4 : 0))
                } else {
                    base
                        .fill(.red
                            .opacity(oneOfThreeSelected ? 0.4 : 0))
                }
                content
                    .padding()
                    .minimumScaleFactor(0.1)
                    .aspectRatio(Constats.cardAspectRatio, contentMode: .fill)
            } else {
                base
                    .stroke(lineWidth: isChosen ? 5 : 1)
                    .foregroundColor(isChosen ? .blue : .gray)
                base
                    .fill(Color.mint)
            }
        }
        .rotation3DEffect(Angle.degrees(rotation), axis: (0, 1, 0))
    }
    
    private struct Constats {
        static let cardAspectRatio: CGFloat = 2/3
        static let cornerRadius: CGFloat = 12
    }
}

extension View {
    func cardify(onTheTable: Bool, isChosen: Bool, isMatched: Bool, oneOfThreeSelected: Bool) -> some View {
        self.modifier(Cardify(onTheTable: onTheTable, isChosen: isChosen, isMatched: isMatched, oneOfThreeSelected: oneOfThreeSelected))
    }
}

