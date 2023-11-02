//
//  CardView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 08.10.2023.
//

import SwiftUI

struct CardView: View {
    var card: Card
    private var cardIsBlank = false
    let threeCardsAreSelected: Bool
    
    init(_ card: Card, threeCardsAreSelected: Bool) {
        self.card = card
        self.threeCardsAreSelected = threeCardsAreSelected
    }
    
    var body: some View {
        //TODO: concider the discard pile
        if card.isFacedUp || !card.isMatched {
            ShapeView(card: card)
                .cardify(threeCardsAreSelected: threeCardsAreSelected,
                         card: card)
    //            .transition(.asymmetric(insertion: .identity, removal: .identity))
                .transition(.scale)
        } else {
            Color.clear
        }
        
    }
    
    typealias Card = GameSetModel<CardContent>.Card
}

