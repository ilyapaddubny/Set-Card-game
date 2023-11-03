//
//  Cardify.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 26.10.2023.
//

import SwiftUI

struct Cardify: ViewModifier, Animatable {
    typealias Card = GameSetModel<CardContent>.Card
    var card: Card
    private let base = RoundedRectangle(cornerRadius: Constats.cornerRadius)
    
    var isFacedUp: Bool {
        rotation < 90.0
       }
    
    let threeCardsAreSelected: Bool
    var rotation: Double
    
    var animatableData: Double {
        get { rotation }
        set { 
            print ("😀 \(newValue)")
            rotation = newValue }
    }
    
    init(threeCardsAreSelected: Bool, card: Card) {
        self.threeCardsAreSelected = threeCardsAreSelected
        self.card = card
        rotation = card.isFacedUp ? 0.0 : 180.0
    }
    
    func body(content: Content) -> some View {
        ZStack {
                base
                    .strokeBorder(lineWidth: card.isChosen ? 3 : 1)
                    .foregroundStyle(card.isChosen ? .blue : .gray)
                    .overlay {
                        content
                            .padding()
                            .minimumScaleFactor(0.1)
                            .aspectRatio(Constats.cardAspectRatio, contentMode: .fill)
                    }
                    .background {
                        ZStack {
                            base.fill(.white)
                        }
                        if threeCardsAreSelected && card.isChosen {
                            base
                                .fill(card.isMatched ? .green : .red)
                                .opacity(0.4)
                        }
                    }
                    .opacity(isFacedUp ? 1 : 0)

                base
                    .stroke(lineWidth: card.isChosen ? 3 : 1)
                    .foregroundColor(card.isChosen ? .blue : .gray)
                    .background(base.fill(Color.mint))
                    .opacity(isFacedUp ? 0 : 1)
        }
        .rotation3DEffect(.degrees(rotation), axis: (0, 1, 0))
    }
    
    
    private struct Constats {
        static let cardAspectRatio: CGFloat = 2/3
        static let cornerRadius: CGFloat = 12
    }
}

extension View {
    func cardify(threeCardsAreSelected: Bool, card: GameSetModel<CardContent>.Card) -> some View {
        self.modifier(Cardify(threeCardsAreSelected: threeCardsAreSelected, card: card))
    }
}

