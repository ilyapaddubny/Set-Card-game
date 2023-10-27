//
//  ContentView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import SwiftUI

struct GameSetView: View {
    typealias Card = GameSetModel<CardContent>.Card
    
    private var discardedCards: [Card] {
        viewModel.cards.filter { !$0.onTheTable && $0.isMatched}
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !$0.onTheTable && !$0.isMatched}
    }
    
    private var dealtCards: [Card] {
        viewModel.cards.filter { $0.onTheTable}
    }
    
    @Namespace private var dealingNamespace
    @Namespace private var discardCards
    
    @StateObject var viewModel: GameSetViewModel
    
    var body: some View {
        VStack {
            Text("Set").font(.title)
            cards
                .animation(.default, value: viewModel.cards)
            buttonsSection
        }
        .padding()
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
    
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(dealtCards, aspectRatio: Constants.cardAspectRatio) { card in
            CardView(card, oneOfThreeSelected: viewModel.threeCardsSelected)
                .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                .matchedGeometryEffect(id: card.id, in: discardCards)
                .overlay(FlyingText(isSet: card.isMatched && viewModel.threeCardsSelected && card.onTheTable))
                .shake(movement: (!card.isMatched && viewModel.threeCardsSelected && card.onTheTable ? 1.0 : 0.0))
                .zIndex(card.isMatched && viewModel.threeCardsSelected && card.onTheTable || (!card.isMatched && viewModel.threeCardsSelected && card.onTheTable) ? 1 : 0)
                .padding(4)
                .onTapGesture {
                    withAnimation {
                        viewModel.choose(card)
                    }
                }
        }
    }
    
    
    var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                withAnimation {
                    CardView(card, oneOfThreeSelected: false)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .offset(x: (undealtCards.suffix(1).contains(card) ? 2 : 0),
                                y: (undealtCards.suffix(1).contains(card) ? 1 : 0))
                        .zIndex(undealtCards.suffix(1).contains(card) ? 0 : 1)
                }
            }
            Text("\(undealtCards.count)")
                .foregroundStyle(.black)
                .zIndex(1)
        }
        .frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
        .onTapGesture {
            if !undealtCards.isEmpty {
                if viewModel.setSelected() {
                    //                    TODO: add replacement at the exact place on the table
                    viewModel.replaceMachedCards()
                } else {
                    viewModel.addThreeMoreCards()
                }
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
            ForEach(discardedCards) { card in
                CardView(card, oneOfThreeSelected: false)
                    .matchedGeometryEffect(id: card.id, in: discardCards)
            }
        }.frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
    }
    
    private struct Constants {
        static let discardPileWith = 50.0
        static let cardAspectRatio: CGFloat = 2/3
       
    }
    
}

#Preview {
    GameSetView(viewModel: GameSetViewModel())
}
