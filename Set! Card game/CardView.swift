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
            ShapeView(card: card)
                .cardify(threeCardsAreSelected: threeCardsAreSelected,
                         card: card)
//                .transition(.asymmetric(insertion: .identity, removal: .scale))
//                .transition(.scale)
        
    }
    
    typealias Card = GameSetModel<CardContent>.Card
    
    @ViewBuilder
    static var blank: some View {
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

