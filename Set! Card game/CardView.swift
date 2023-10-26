//
//  CardView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 08.10.2023.
//

import SwiftUI

struct CardView: View {
    typealias Card = GameSetModel<CardContent>.Card
    let card: Card
    private var cardIsBlank = false
    
    //returns a cardView
    init(_ card: Card) {
        self.card = card
    }
    
    //returns a blank cardView
    init() {
        self.cardIsBlank = true
        self.card = Card(content: CardContent(colorName: "", opacity: 0, shape: .circle, numberOfItems: 1))
    }
    
    var body: some View {
        if !cardIsBlank {
            cardView
        } else {
            blankCardView
        }
    }
    
    private var cardView: some View {
        ShapeView(card: card)
            .cardify(onTheTable: card.onTheTable,
                     isChosen: card.isChosen,
                     isMatched: card.isChosen,
                     oneOfThreeSelected: card.oneOfThreeSelected)
    }
    
    @ViewBuilder
    private var blankCardView: some View {
        let base = RoundedRectangle(cornerRadius: 12)
        ZStack(alignment: .center) {
            base
                .stroke(lineWidth: 1)
            base
                .fill(.gray)
                .opacity(0.3)
            Image(systemName: "nosign")
                .font(.largeTitle)
        }
    }
    
    
}

