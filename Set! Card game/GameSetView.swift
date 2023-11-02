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
        VStack {
            Text("Set").font(.title)
            cards
            buttonsSection
        }
        .padding()
    }
    
    var buttonsSection: some View {
        HStack {
            discardPile
            Spacer()
            testLeft
            Spacer()
            newGameButton
            Spacer()
            testRight
            Spacer()
            deck
        }.padding()
    }
    
    //MARK: - Cards
    @ViewBuilder
    private var cards: some View {
//        AspectVGrid(viewModel.faceUpCards.filter({!isDiscarded($0)}), aspectRatio: Constants.cardAspectRatio) { card in
        AspectVGrid(viewModel.cards.filter({!isDiscarded($0) && $0.isFacedUp}), aspectRatio: Constants.cardAspectRatio) { card in
            if !isDealt(card) {
                Color.clear
            } else {
                withAnimation {
                    CardView(card, threeCardsAreSelected: viewModel.threeCardsSelected)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .overlay(FlyingText(isSet: card.isMatched && thereIsASetOnTheTable))
                        .shake(movement: (!card.isMatched && viewModel.threeCardsSelected && card.isFacedUp && card.isChosen ? 1.0 : 0.0))
//                        .zIndex(card.isMatched && thereIsASetOnTheTable || (!card.isMatched && viewModel.threeCardsSelected && card.isFacedUp) ? 1 : 0)
                        .padding(2)
                        .onTapGesture {
                            withAnimation {
                                discardCards()
                                viewModel.choose(card)
                            }
                        }
                }
            }
        }
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
    
    private func dealAnimation(order: Int) -> Animation {
        let delay = Double(order) * Constants.delayDuration
        return Animation.easeInOut(duration: Constants.dealDuration).delay(delay)
    }
    
    private func flipAnimation(order: Int) -> Animation {
        let delay = Double(order) * Constants.delayDuration
        return Animation.easeInOut(duration: 1).delay(delay)
    }
    
    
//    private func dealNumberOfCards(_ numberOfCards: Int) {
//        var delay: TimeInterval = 0
//        var cardsAdded = 0
//        
//        for card in viewModel.cards.filter({!isDealt($0)}) {
//            viewModel.setCardToFacedUp(card)
//            withAnimation(Constants.dealAnimation.delay(delay)) {
//                let _ = dealtCards.insert(card.id)
//            }
//            delay += Constants.dealInterval
//            cardsAdded += 1
//            
//            if cardsAdded >= numberOfCards {
//                break
//            }
//        }
//    }
    
    //MARK: - Deck
    var deck: some View {
        ZStack {
            ForEach(viewModel.cards.filter( {!isDealt($0)} )) { card in
                withAnimation {
                    CardView(card, threeCardsAreSelected: viewModel.threeCardsSelected)
                        .matchedGeometryEffect(id: card.id, in: dealingNamespace)
                        .offset(x: (undealtCards.suffix(1).contains(card) ? 2 : 0),
                                y: (undealtCards.suffix(1).contains(card) ? 1 : 0))
                        .zIndex(undealtCards.suffix(1).contains(card) ? 0 : 1)
                }
            }
//            Text("\(viewModel.cards.filter({!isDealt($0)}).count)")
//                .foregroundStyle(.black)
//                .zIndex(1)
        }
        .frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
        .onTapGesture {
//            if !undealtCards.isEmpty {
                if dealtCards.isEmpty {
//                        dealNumberOfCards(12)
                    for i in 0..<12 {
                        withAnimation(flipAnimation(order: i)) {
                            viewModel.drawCard()
                        }
                    }
                    var j = 0
                    for card in viewModel.faceUpCards.filter( { !isDealt($0) } ) {
                        withAnimation(dealAnimation(order: j)) {
                            deal(card)
                            j+=1
                        }
                    }
                } else {
//                    discardCards()
//                    dealNumberOfCards(3)
                    
                    let discarding = areCardsToDiscard()
                    discardCards()
                    for i in 0..<3 {
                        withAnimation(flipAnimation(order: discarding ? i+1 : i)) {
                            viewModel.drawCard()
                        }
                    }
                    var j = 0
                    if discarding { j+=1 }
                    for card in viewModel.faceUpCards.filter( { !isDealt($0) } ) {
                        withAnimation(dealAnimation(order: j)) {
                            deal(card)
                            j+=1
                        }
                    }
                }
//            }
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
    
    private func discard(_ card: Card) {
        discardedCards.insert(card.id)
    }
    
    private func isDiscarded(_ card: Card) -> Bool {
        discardedCards.contains(card.id)
    }
    
    @State private var discardedCards = Set<Card.ID>()
    
    var newGameButton: some View {
        Button {
            withAnimation {
                dealtCards.removeAll()
                discardedCards.removeAll()
                viewModel.newGame()
            }
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
    
    //MARK: - Discard Pile
    var discardPile: some View {
        ZStack {
            blankCardView
            ForEach(viewModel.cards.filter({isDiscarded($0)})) { card in
                CardView(card, threeCardsAreSelected: viewModel.threeCardsSelected)
                    .matchedGeometryEffect(id: card.id, in: dealingNamespace)
            }
        }.frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
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
    
    //MARK: - test
    var testLeft: some View {
        
        ZStack {
            //!!! Она уже есть
            ForEach(viewModel.card.filter( {$0.isFacedUp} )) { card in
                view(for: card)
                    .onTapGesture {
                        withAnimation(flipAnimation(order: 5)) {
                            viewModel.test()
                            dealtCards.insert(card.id)
                        }
                        
                    }
            }
                
            }
        .frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
//        .background(.blue)
    }
    
    
    
    private var undealtCardsTest: [Card] {
            viewModel.card.filter { !isDealtTest($0) }
        }
    
    private func isDealtTest(_ card: Card) -> Bool {
        dealtCardsTest.contains(card.id)
    }
    
    @State private var dealtCardsTest = Set<Card.ID>()
    
    var testRight: some View {
        //ITS CREATING
        
        ZStack {
            ForEach(undealtCardsTest) { card in
                view(for: card)
                    .onTapGesture {
                        withAnimation(flipAnimation(order: 5)) {
                            viewModel.test()
                            dealtCards.removeAll()
                        }
                        
                    }
            }
            
            }
        .frame(width: Constants.discardPileWith, height: Constants.discardPileWith / Constants.cardAspectRatio)
//        .background(.blue)
    }
    
    private func view(for card: Card) -> some View {
           CardView(card, threeCardsAreSelected: viewModel.threeCardsSelected)
               .matchedGeometryEffect(id: card.id, in: test)
               .transition(.asymmetric(insertion: .identity, removal: .identity))
       }
    
    @Namespace private var test
    @Namespace private var test2
    
    private struct Constants {
        static let discardPileWith = 50.0
        static let cardAspectRatio: CGFloat = 2/3
        
        
        static let delayDuration: Double = 0.15
        static let dealDuration: Double = 2
    }
    
}

#Preview {
    GameSetView(viewModel: GameSetViewModel())
}

