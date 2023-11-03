//
//  ContentView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import SwiftUI

struct GameSetView: View {
    typealias Card = GameSetModel<CardContent>.Card
    
    @Namespace private var dealingNamespace
    @StateObject var viewModel: GameSetViewModel
    
    var body: some View {
        ZStack {
            VStack {
                cards
                buttonsSection
            }
        }.padding()
        
    }
    
    var buttonsSection: some View {
        
        HStack {
            VStack {
                discardPile
                newGameButton
            }
            
            Spacer()
            Text("I love Zina!").font(.title)
            Spacer()
            VStack {
                deck
                Text("\(undealtCards.count) left")
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 2)
    }
    
    var newGameButton: some View {
        Button("New Game") {
            withAnimation {
                dealtCards.removeAll()
                discardedCards.removeAll()
                viewModel.newGame()
            }
        }
    }
    
    
    //MARK: - Cards
    private var cards: some View {
        AspectVGrid(viewModel.cards.filter( {$0.isFacedUp && !isDiscarded($0)} ), aspectRatio: Constants.cardAspectRatio) { card in
            if !isDealt(card) {
                Color.clear
            } else {
                withAnimation {
                    view(for: card)
                        .overlay(FlyingText(isSet: card.isMatched && thereIsASetOnTheTable))
                        .shake(movement: (!card.isMatched && viewModel.threeCardsSelected && card.isFacedUp && card.isChosen ? 1.0 : 0.0))
                        .zIndex(card.isMatched && thereIsASetOnTheTable || (!card.isMatched && viewModel.threeCardsSelected && card.isFacedUp) ? 1 : 0)
                        .padding(3)
                        .onTapGesture {
                            discardCards()
                            viewModel.choose(card)
                        }
                }
            }
        }
    }
    
    
    
    private func dealAnimation(order: Int) -> Animation {
        let delay = Double(order) * Constants.delayDuration
        return Animation.easeInOut(duration: Constants.dealDuration).delay(delay)
    }
    
    private func flipAnimation(order: Int) -> Animation {
        let delay = Double(order) * Constants.delayDuration
        return Animation.easeInOut.delay(delay)
    }
    
    private func view(for card: Card) -> some View {
        CardView(card, threeCardsAreSelected: viewModel.threeCardsSelected)
            .matchedGeometryEffect(id: card.id, in: dealingNamespace)
    }
    

    @State private var dealtCards = Set<Card.ID>()
    
    private func isDealt(_ card: Card) -> Bool {
        dealtCards.contains(card.id)
    }
    
    private func deal(_ card: Card) {
        dealtCards.insert(card.id)
    }
    
    private var undealtCards: [Card] {
        viewModel.cards.filter({!isDealt($0)})
    }
    
    //MARK: - Deck
    var deck: some View {
        ZStack {
            ForEach(undealtCards) { card in
                withAnimation {
                    view(for: card)
                        .offset(x: (undealtCards.suffix(1).contains(card) ? 2 : 0),
                                y: (undealtCards.suffix(1).contains(card) ? 1 : 0))
                        .zIndex(undealtCards.suffix(1).contains(card) ? 0 : 1)
                }
            }
        }
        .frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
        .onTapGesture {
            if dealtCards.isEmpty {
                for i in 0..<12 {
                    withAnimation(flipAnimation(order: i)) {
                        viewModel.drawCard()
                    }
                }
                var j = 0
                for card in viewModel.cards.filter( { $0.isFacedUp && !isDealt($0) } ) {
                    withAnimation(dealAnimation(order: j)) {
                        deal(card)
                        j+=1
                    }
                }
            } else {
                let discarding = areCardsToDiscard()
                discardCards()
                
                for i in 0..<3 {
                    withAnimation(flipAnimation(order: discarding ? i+1 : i)) {
                        viewModel.drawCard()
                    }
                }
                var j = 0
//                if discarding == true { j+=3 }
                for card in viewModel.cards.filter( { $0.isFacedUp && !isDealt($0) } ) {
                    withAnimation(dealAnimation(order: discarding ? j+1 : j)) {
                        deal(card)
                        j+=1
                    }
                }
            }
        }
    }
    
    private func areCardsToDiscard() -> Bool {
        let count = viewModel.cards.filter( { $0.isMatched == true && !isDiscarded($0) } ).count
        if count == 0 {
            return false
        } else {
            return true
        }
    }
    
    private var thereIsASetOnTheTable: Bool {
        viewModel.cards.filter( { $0.isMatched && !isDiscarded($0)}).count == 3
    }
    
    private func discardCards() {
        var i = 0
        for card in viewModel.cards.filter( { $0.isMatched && !isDiscarded($0) } ) {
            withAnimation(dealAnimation(order: i)) {
                discard(card)
                i+=1
            }
        }
    }

    
    //MARK: - Discard Pile logic
    var discardPile: some View {
        ZStack {
            CardView.blank
            ForEach(viewModel.cards.filter({isDiscarded($0)})) { card in
                CardView(card, threeCardsAreSelected: viewModel.threeCardsSelected)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }.frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
    }
    
    
    private func discard(_ card: Card) {
        discardedCards.insert(card.id)
    }
    
    private func isDiscarded(_ card: Card) -> Bool {
        discardedCards.contains(card.id)
    }
    
    @State private var discardedCards = Set<Card.ID>()
    
    var shaffleButton: some View {
        Button {
//            viewModel.shuffle()
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
    
    private struct Constants {
        static let discardPileWith = 50.0
        static let cardAspectRatio: CGFloat = 2/3
        
        
        static let delayDuration: Double = 0.25
        static let dealDuration: Double = 0.8
    }
    
}

#Preview {
    GameSetView(viewModel: GameSetViewModel())
}

