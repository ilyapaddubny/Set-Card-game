//
//  SetModel.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import Foundation


                    

struct GameSetModel<CardContent: Equatable> {
    private(set) var deck = [Card]()
    private var numberOfCardsAreSelected: Int {
        deck.filter{$0.isChosen}.count
    }
    private var threeCardsSelected: Int {
        deck.filter{$0.isChosen}.count
    }

    init(numberOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        for index in 0..<numberOfCards {
            let content = cardContentFactory(index)
            deck.append(Card(content: content))
        }
        deck.shuffle()
        addNumberOfCards(12)
    }
    
    mutating func shuffle() {
        deck.shuffle()
    }
    
    
    
    mutating func choose(_ card: GameSetModel<CardContent>.Card, setLogic: (_ cards: [Card]) -> Bool) -> Void {
        
        if numberOfCardsAreSelected < 3 || (card.isChosen && numberOfCardsAreSelected != 3){
            if let cardIndex = deck.firstIndex(where: {$0.id == card.id}) {
                deck[cardIndex].isChosen.toggle()
                removeOneOfThreeSelection()
                removeIsMached()
            }
        }
        
        //set attempt
        if numberOfCardsAreSelected == 3 {
            var selectedCards = [Card]()
            
            //one of three selected logic
            deck.compactMap { $0.isChosen ? $0.id : nil}
                .forEach { id in
                    if let index = deck.firstIndex(where: {$0.id == id}) {
                        deck[index].oneOfThreeSelected = true
                        selectedCards.append(deck[index])
                    }
            }
            
            let nextCardIndex = selectedCards.firstIndex{$0.id == card.id}
            
            if checkTheSetOf(selectedCards, withLogic: setLogic) {
                //it's a Set!
                deck.compactMap {$0.isChosen ? $0.id : nil}
                    .forEach {id in
                        if let index = deck.firstIndex(where: {$0.id == id}) {
                            deck[index].isMatched = true
                            //When any card is touched on and there are already 3 matching Set cards selected, then...
                            guard nextCardIndex != nil else {
                                //...seletc the chosen card
                                if let cardIndex = deck.firstIndex(where: {$0.id == card.id}) {
                                    deck[cardIndex].isChosen = true
                                }
                                //...and deal with Set!
                                replaceCard(at: index)
                                return
                            }
                        }
                    }
            }
        }
    }
    
    mutating func checkTheSetOf(_ cards: [Card], withLogic logic: (_ cards: [Card]) -> Bool) -> Bool {
            return logic(cards)
        }
    
    mutating func removeOneOfThreeSelection() {
        deck.compactMap { $0.oneOfThreeSelected ? $0.id : nil }
            .forEach { id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].oneOfThreeSelected = false
                }
            }
    }
    
    mutating func removeIsMached() {
        deck.compactMap { $0.isMatched ? $0.id : nil }
            .forEach { id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].isMatched = false
                }
            }
    }
    

    mutating func addNumberOfCards(_ numberOfCards: Int) {
        var cardsAdded = 0
        for index in deck.indices where !deck[index].onTheTable {
            deck[index].onTheTable = true
            cardsAdded += 1
            if cardsAdded >= numberOfCards {
                break
            }
        }
    }
    
    mutating func replaceCard(at index: Int){
        if let newCardFromDeckIndex = deck.firstIndex(where: {!$0.onTheTable}) {
            // ...replace those 3 matching Set cards with new ones
            deck[index] = deck[newCardFromDeckIndex]
            deck[index].onTheTable = true
            deck.remove(at: newCardFromDeckIndex)
        } else {
            // ...deck is empty. Remove card from the screen
            deck.remove(at: index)
        }
        
    }

    
    struct Card: Identifiable, Equatable, CustomStringConvertible {
        static func == (lhs: GameSetModel<CardContent>.Card, rhs: GameSetModel<CardContent>.Card) -> Bool {
            return lhs.content == rhs.content && 
            lhs.id == rhs.id &&
            lhs.isMatched == rhs.isMatched &&
            lhs.isChosen == rhs.isChosen &&
            lhs.onTheTable == rhs.onTheTable &&
            lhs.oneOfThreeSelected == rhs.oneOfThreeSelected
        }
        
        let content: CardContent
        
        var id = UUID()
        
        var isMatched = false
        var isChosen = false
        var onTheTable = false
        var oneOfThreeSelected = false
        
        var description: String {
            "Card id: \(id): \(isMatched ? "Matched" : "") \(isChosen ? "Chosen" : "") \(onTheTable ? "On the table" : "") \(oneOfThreeSelected ? "One of three selected cards" : "") \(content)."
        }
    }
}
