//
//  Cardify.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 26.10.2023.
//

import SwiftUI

struct Cardify: ViewModifier {
    let base = RoundedRectangle(cornerRadius: 12)
    let onTheTable: Bool
    let isChosen: Bool
    let isMatched: Bool
    let oneOfThreeSelected: Bool
    private let cardAspectRatio: CGFloat = 2/3

    
    func body(content: Content) -> some View {
        ZStack(alignment: .center) {
            if onTheTable {
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
                    .aspectRatio(cardAspectRatio, contentMode: .fill)
            } else {
                base
                    .stroke(lineWidth: isChosen ? 5 : 1)
                    .foregroundColor(isChosen ? .blue : .gray)
                base
                    .fill(Color.mint)
            }
        }
    }
}

extension View {
    func cardify(onTheTable: Bool, isChosen: Bool, isMatched: Bool, oneOfThreeSelected: Bool) -> some View {
        self.modifier(Cardify(onTheTable: onTheTable, isChosen: isChosen, isMatched: isMatched, oneOfThreeSelected: oneOfThreeSelected))
    }
}

