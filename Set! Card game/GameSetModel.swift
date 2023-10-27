//
//  SetModel.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import Foundation

struct GameSetModel<CardContent: Equatable> {
    private(set) var deck = [Card]()
    private(set) var deckNotOnTheTable = [Card]()
    
    init(numberOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        for index in 0..<numberOfCards {
            let content = cardContentFactory(index)
            deck.append(Card(content: content))
        }
        deck.shuffle()
        addNumberOfCardsToTheTable(12)
    }
    
    
    private var setSelected: Bool {
        deck.filter{$0.isMatched && $0.onTheTable}.count == 3
    }
    var chosenExactlyThreeCards: Bool {
        get { deck.filter{$0.isChosen && $0.onTheTable}.count == 3 }
        set {}
    }
    
    mutating func choose(_ card: GameSetModel<CardContent>.Card, setLogic: (_ cards: [Card]) -> Bool) -> Void {
        if let index = deck.firstIndex(where: {$0.id == card.id}) {
            if chosenExactlyThreeCards {
                if checkTheSet(withLogic: setLogic) {
                   //set already on the table
                    discardCards()
                    if !deck[index].isChosen {
                        deck[index].isChosen.toggle()
                    }
                    
                } else {
                    unselectAllCards()
                    deck[index].isChosen.toggle()
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
        deck.compactMap {$0.isChosen && $0.onTheTable ? $0.id : nil}
            .forEach {id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].isMatched = true
                }
            }
    }
    
    mutating func discardCards() {
        deck.compactMap {$0.isChosen && $0.onTheTable && $0.isMatched ? $0.id : nil}
            .forEach {id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].onTheTable = false
                    deck[index].isChosen = false
                }
            }
    }
    
    mutating func newGame() {
        for index in deck.indices {
            deck[index].isChosen = false
            deck[index].onTheTable = false
            deck[index].isMatched = false
        }
        deck.shuffle()
        addNumberOfCardsToTheTable(12)
    }
    
    mutating func checkTheSet(withLogic logic: (_ cards: [Card]) -> Bool) -> Bool {
        var selectedCards = [Card]()
        deck.compactMap { $0.isChosen ? $0.id : nil}
            .forEach { id in
                if let index = deck.firstIndex(where: {$0.id == id}) {
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
        for index in deck.indices where !deck[index].onTheTable && !deck[index].isMatched {
            deck[index].onTheTable = true
            cardsAdded += 1
            if cardsAdded >= numberOfCards {
                break
            }
        }
    }
    
    
    mutating func removeMachedCards() {
        deck.compactMap { $0.isMatched ? $0.id : nil }
            .forEach { id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    removeCard(at: index)
                }
            }
    }
    
    private mutating func removeCard(at index: Int) {
//        discardPile.append(deck[index])
        deck[index].onTheTable = false
//        deck.remove(at: index)
//        TODO: change .remove logic
    }
    
    mutating func shuffle() {
        deck = deck.filter { $0.onTheTable }.shuffled() + deck.filter { !$0.onTheTable }
    }
    
    func ifSetSelected() -> Bool {setSelected}
    
    
     // Code was depricated since the logic has changed
    mutating func replaceMachedCards() {
        deck.compactMap { $0.isMatched && $0.onTheTable ? $0.id : nil }
            .forEach { id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].onTheTable = false
                    dealCardFromDeck()
                }
            }
    }
    
    private mutating func dealCardFromDeck() {
        if let newCardFromDeckIndex = deck.firstIndex(where: {!$0.onTheTable && !$0.isMatched}) {
            deck[newCardFromDeckIndex].onTheTable = true
        }
    }

    
    struct Card: Identifiable, Equatable, CustomStringConvertible {
        static func == (lhs: GameSetModel<CardContent>.Card, rhs: GameSetModel<CardContent>.Card) -> Bool {
            return lhs.content == rhs.content && 
            lhs.id == rhs.id &&
            lhs.isMatched == rhs.isMatched &&
            lhs.isChosen == rhs.isChosen &&
            lhs.onTheTable == rhs.onTheTable
        }
        
        let content: CardContent
        
        var id = UUID()
        
        var isMatched = false
        var isChosen = false
        var onTheTable = false {
            didSet {
                if oldValue == true {
                    self.isChosen = false
                }
            }
        }
    
        var description: String {
            "Card id: \(id): \(isMatched ? "Matched" : "") \(isChosen ? "Chosen" : "") \(onTheTable ? "On the table" : "") \(content)."
        }
    }
}
