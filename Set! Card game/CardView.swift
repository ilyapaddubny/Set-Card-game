//
//  CardView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 08.10.2023.
//

import SwiftUI

struct CardView: View {
    let card: Card
    private var cardIsBlank = false
    let threeCardsAreSelected: Bool
    
    init(_ card: Card, threeCardsAreSelected: Bool) {
        self.card = card
        self.threeCardsAreSelected = threeCardsAreSelected
    }
    
    var body: some View {
        ShapeView(card: card)
            .cardify(threeCardsAreSelected: threeCardsAreSelected,
                     card: card)
    }
    
    typealias Card = GameSetModel<CardContent>.Card
}

