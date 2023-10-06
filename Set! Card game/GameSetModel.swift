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
        addNumberOfCardsToTheTable(12)
    }
    
    mutating func shuffle() {
        deck.shuffle()
    }
    
    var chosenExactlyThreeCards: Bool {
        get { deck.filter{$0.isChosen}.count == 3 }
        set { deck.indices.forEach { deck[$0].oneOfThreeSelected = newValue} }
    }
    
    mutating func choose(_ card: GameSetModel<CardContent>.Card, setLogic: (_ cards: [Card]) -> Bool) -> Void {
        if let index = deck.firstIndex(where: {$0.id == card.id}) {
            if chosenExactlyThreeCards {
                //user selectes card whet already 3 cards has been selected
                if card.isChosen {
                    //user shosen one of selected cards
                    if checkTheSet(withLogic: setLogic) {
                        //set on the table
                        //do nothing
                    } else {
                        //no set on the table
                        //deselect 3 cards and select chosen one again
                        chosenExactlyThreeCards = false
                        unselectAllCards()
                        deck[index].isChosen.toggle()
                    }
                } else {
                    //user selects the another (4th card)
                    if checkTheSet(withLogic: setLogic) {
                        //set on the table
                        //replace the set with new 3 cards from a deck or delete empty spots if deck is empty
                        replaceMachedCards()
                        unselectAllCards()
                        deck[index].isChosen.toggle()
                    } else {
                        //no set on the table
                        //deselect 3 cards and select a new one
                        unselectAllCards()
                        chosenExactlyThreeCards = false
                        deck[index].isChosen.toggle()
                    }
                }
            } else {
                //user selected 1st, 2nd or 3rd card
                deck[index].isChosen.toggle()
                if chosenExactlyThreeCards {
                    //user selected 3rd
                    if checkTheSet(withLogic: setLogic) {
                        markCardsFromSet()
                    }
                }
            }
        }
    }
    
    mutating func markCardsFromSet() {
        deck.compactMap {$0.isChosen ? $0.id : nil}
            .forEach {id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].isMatched = true
                }
            }
    }
    
    mutating func checkTheSet(withLogic logic: (_ cards: [Card]) -> Bool) -> Bool {
        var selectedCards = [Card]()
        deck.compactMap { $0.isChosen ? $0.id : nil}
            .forEach { id in
                if let index = deck.firstIndex(where: {$0.id == id}) {
                    deck[index].oneOfThreeSelected = true
                    selectedCards.append(deck[index])
                }
            }
        
        return logic(selectedCards)
    }
    
    mutating func unselectAllCards() {
        deck.compactMap { $0.isChosen ? $0.id : nil }
            .forEach { id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].isChosen = false
                }
            }
    }
    
    mutating func addNumberOfCardsToTheTable(_ numberOfCards: Int) {
        var cardsAdded = 0
        for index in deck.indices where !deck[index].onTheTable {
            deck[index].onTheTable = true
            cardsAdded += 1
            if cardsAdded >= numberOfCards {
                break
            }
        }
    }
    
    private mutating func replaceMachedCards() {
        deck.compactMap { $0.isMatched ? $0.id : nil }
            .forEach { id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    replaceCard(at: index)
                }
            }
    }
    
    private mutating func replaceCard(at index: Int){
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
