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
    var body: some View {
        VStack {
            Text("Set").font(.title)
            cards
                .animation(.default, value: viewModel.cards)
            buttonsSection
        }
        .padding()
    }
    
    //    set of cards
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(viewModel.cards.filter({$0.onTheTable}), aspectRatio: cardAspectRatio) { card in
            if card.onTheTable {
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                    .matchedGeometryEffect(id: card.id, in: discardCards)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                    }
            }
        }
        .onAppear {
            //animation
            
        }
        
    }
    
    var buttonsSection: some View {
        HStack {
            discardPile
            Spacer()
            newGameButton
            Spacer()
            deck
        }.padding()
    }
    
    //    @State private var dealt = Set<Card.ID>()
    
    //    private func isDealt(_ card: Card) -> Bool {
    //        dealt.contains(card.id)
    //    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter { !$0.onTheTable }
    }
    @Namespace private var dealingNamespace
    
    
    var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                CardView(card)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }
        .frame(width: discardPileWith, height: discardPileWith / cardAspectRatio)
        .onTapGesture {
            withAnimation(.easeInOut) {
                if viewModel.setSelected() {
                    viewModel.replaceMachedCards()
//                    viewModel.removeMachedCards()
//                    viewModel.addThreeMoreCards()
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
    
    @Namespace private var discardCards
    
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
