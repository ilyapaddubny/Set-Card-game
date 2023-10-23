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
    private let shapeAspectRatio: CGFloat = 2/1
    private let cardAspectRatio: CGFloat = 2/3
    private let contentPadding: CGFloat = 4
    private var cardIsBlank = false
    
    let base = RoundedRectangle(cornerRadius: 12)
    
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
        ZStack(alignment: .center) {
            if card.onTheTable {
                base
                    .stroke(lineWidth: card.isChosen ? 5 : 1)
                    .foregroundColor(card.isChosen ? .blue : .gray)
                base
                    .fill(.white)
                if (card.isMatched) {
                    base
                        .fill(.green
                            .opacity(card.oneOfThreeSelected ? 0.4 : 0))
                } else {
                    base
                        .fill(.red
                            .opacity(card.oneOfThreeSelected ? 0.4 : 0))
                }
                content
                    .padding()
                    .minimumScaleFactor(0.1)
                    .aspectRatio(cardAspectRatio, contentMode: .fill)
            } else {
                base
                    .stroke(lineWidth: card.isChosen ? 5 : 1)
                    .foregroundColor(card.isChosen ? .blue : .gray)
                base
                    .fill(Color.mint)
            }
        }
        
    }
    
    private var blankCardView: some View {
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
    
    //    creates needed number of shapes
    @ViewBuilder
    var content: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                ForEach(0..<card.content.numberOfItems, id: \.self) {index in
                    shape(geometry: geometry, index: index)
                        .padding([.top, .bottom], contentPadding/2)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    //    shape dreation
    @ViewBuilder
    func shape(geometry: GeometryProxy, index: Int) -> some View {
        switch card.content.shape {
        case .circle:
            ZStack {
                Circle()
                    .stroke(lineWidth: card.content.opacity == OneOfThree.one.opacity ?  3 : 1)
                    .foregroundColor(card.content.opacity == OneOfThree.one.opacity ? card.content.color : .black)
                    .frame(height: geometry.size.height/3-contentPadding)
                Circle()
                    .foregroundColor(card.content.color)
                    .opacity(card.content.opacity)
                    .frame(height: geometry.size.height/3-contentPadding)
            }
            
        case .diamond:
            ZStack {
                DiamondShape()
                    .stroke(lineWidth: card.content.opacity == OneOfThree.one.opacity ?  3 : 1)
                    .foregroundColor(card.content.opacity == OneOfThree.one.opacity ? card.content.color : .black)
                    .frame(height: geometry.size.height/3-contentPadding)
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
                
                DiamondShape()
                    .foregroundColor(card.content.color)
                    .opacity(card.content.opacity)
                    .frame(height: geometry.size.height/3-contentPadding)
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
            }
            
        case.wavedShape:
            ZStack {
                WavedShape()
                    .stroke(lineWidth: card.content.opacity == OneOfThree.one.opacity ?  3 : 1)
                    .foregroundColor(card.content.opacity == OneOfThree.one.opacity ? card.content.color : .black)
                    .frame(height: geometry.size.height/3-contentPadding)
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
                
                WavedShape()
                    .foregroundColor(card.content.color)
                    .opacity(card.content.opacity)
                    .frame(height: geometry.size.height/3-contentPadding)
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
                
            }
        }
    }
}

