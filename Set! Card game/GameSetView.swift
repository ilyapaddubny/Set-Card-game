//
//  ContentView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import SwiftUI

struct GameSetView: View {
    typealias Card = GameSetModel<CardContent>.Card
    
    @StateObject var viewModel = GameSetViewModel()
    private let discardPileWith = 50.0
    private let cardAspectRatio: CGFloat = 2/3
    
    @Namespace private var dealingNamespace
    @Namespace private var discardCards
    
    var body: some View {
       
        VStack {
            Text("Set").font(.title)
            cards
                .animation(.default, value: viewModel.cards)
            buttonsSection
        }
        .padding()
    }
    
    @State var missAtimation = 1
    //    set of cards
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(viewModel.cards.filter({$0.onTheTable}), aspectRatio: cardAspectRatio) { card in
            if card.onTheTable {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardCards)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .overlay(FlyingText(isSet: card.isMatched && card.oneOfThreeSelected && card.onTheTable))
                    .shake(movement: (!card.isMatched && card.oneOfThreeSelected && card.onTheTable ? 1.0 : 0.0))
                    .zIndex(card.isMatched && card.oneOfThreeSelected && card.onTheTable || (!card.isMatched && card.oneOfThreeSelected && card.onTheTable) ? 1 : 0)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
    }
    
    
    var buttonsSection: some View {
        HStack {
            discardPile
            Spacer()
            newGameButton
            Spacer()
            shaffleButton
            Spacer()
            deck
        }.padding()
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !$0.onTheTable }
    }
    
    var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .transition(.asymmetric(insertion: .identity, removal: .identity))
                    .offset(x: (undealtCards.suffix(1).contains(card) ? 2 : 0),
                            y: (undealtCards.suffix(1).contains(card) ? 1 : 0))
                    .zIndex(undealtCards.suffix(1).contains(card) ? 0 : 1)
            }
            Text("\(undealtCards.count)")
                .foregroundStyle(.black)
                .zIndex(1)
        }
        .frame(width: discardPileWith, height: discardPileWith / cardAspectRatio)
        .onTapGesture {
                if viewModel.setSelected() {
                    viewModel.replaceMachedCards()
                } else {
                    viewModel.addThreeMoreCards()
                }
            
        }
    }
    
    var newGameButton: some View {
        Button {
            viewModel.newGame()
        } label: {
            Text("New game")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                }
        }
    }
    
    
    var shaffleButton: some View {
        Button {
            viewModel.shuffle()
        } label: {
            Text("Shaffle")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(8)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                }
        }
    }
    
    
    
    var discardPile: some View {
        ZStack {
            CardView()
            ForEach(viewModel.discardPile) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: discardCards)
            }
        }.frame(width: discardPileWith, height: discardPileWith / cardAspectRatio)
    }
    
}

#Preview {
    GameSetView()
}

extension View {
    func shake(movement: CGFloat) -> some View {
        self.modifier(Shake(movement:movement))
    }
    
}
