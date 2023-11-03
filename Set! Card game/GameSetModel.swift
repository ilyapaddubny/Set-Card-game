//
//  SetModel.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import Foundation

struct GameSetModel<CardContent: Equatable> {
    private(set) var deck = [Card]()
    
    init(numberOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        for index in 0..<numberOfCards {
            let content = cardContentFactory(index)
            deck.append(Card(content: content))
        }
        deck.shuffle()
        
        //test
        createTest(content: cardContentFactory(1))
    }
    
    var chosenExactlyThreeCards: Bool {
        get { deck.filter{$0.isChosen}.count == 3 }
        set {}
    }
    
    mutating func choose(_ card: GameSetModel<CardContent>.Card, setLogic: (_ cards: [Card]) -> Bool) -> Void {
        if let index = deck.firstIndex(where: {$0.id == card.id}) {
            if chosenExactlyThreeCards {
                unselectAllCards()
                deck[index].isChosen.toggle()
            } else {
                //user selected 1st, 2nd or 3rd card
                if !deck[index].isMatched {
                    deck[index].isChosen.toggle()
                }
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
        deck.compactMap {$0.isChosen && $0.isFacedUp && !$0.isMatched ? $0.id : nil}
            .forEach {id in
                if let index = deck.firstIndex(where: { $0.id == id }) {
                    deck[index].isMatched = true
                }
            }
    }
    
    mutating func newGame() {
        for index in deck.indices {
            deck[index].isChosen = false
            deck[index].isMatched = false
            deck[index].isFacedUp = false
        }
        deck.shuffle()
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
    
    private(set) var testCards = [GameSetModel<CardContent>.Card]()
    
    mutating func createTest(content: CardContent) {
        let testCard = Card(content: content)
        testCards.append(testCard)
    }
    
    mutating func test() {
        testCards[0].isFacedUp.toggle()
        testCards[0].isChosen.toggle()
    }
    
    private var selectedCardsIndices: [Int] {
        get { deck.indices.filter({deck[$0].isChosen}) }
    }
    
    mutating func drawNamberOfCards(_ numberOfCards: Int) {
        if numberOfCards > deck.filter({!$0.isFacedUp && !$0.isMatched}).count {
            return
        }
        
        if selectedCardsIndices.count > 0 {
            //TODO: fixe the potintial error
            if deck[selectedCardsIndices[0]].isMatched == true {
                swapMatchedWithNewCard(selectedCardsIndices[0])
                return
            }
            if deck[selectedCardsIndices[1]].isMatched == true {
                swapMatchedWithNewCard(selectedCardsIndices[1])
                return
            }
            if deck[selectedCardsIndices[2]].isMatched == true {
                swapMatchedWithNewCard(selectedCardsIndices[2])
                return
            }
        }
        
        for _ in 0 ..< numberOfCards {
            guard let index = deck.firstIndex(where: {!$0.isFacedUp}) else { return }
            deck[index].isFacedUp = true
        }
    }
    
    private mutating func swapMatchedWithNewCard(_ matchedCardIndex: Int) {
        deck[matchedCardIndex].isChosen = false
        if let index = deck.firstIndex(where: {!$0.isFacedUp && !$0.isMatched}) {
            deck[index].isFacedUp = true
            deck.swapAt(index, matchedCardIndex)
        } else {
            return
        }
    }
    
    struct Card: Identifiable, Equatable, CustomStringConvertible {
        let content: CardContent
        
        var id = UUID()
        var isMatched = false {
            didSet {
                print ("✅ isMatched didSet \(oldValue)")
            }
        }
        var isChosen = false
        var isFacedUp = false{
            didSet {
                print ("✅ isFacedUp didSet \(oldValue)")
            }
        }
        
        var description: String {
            "Card id: \(id) \(isMatched ? "Matched" : "") \(isChosen ? "Chosen" : "") \(isFacedUp ? "FacedUp" : "") \(content)."
        }
    }
    
    
    
    
    
    //    mutating func addNumberOfCardsToTheTable(_ numberOfCards: Int) {
    //        var cardsAdded = 0
    //        for index in deck.indices where !deck[index].isFacedUp {
    //            deck[index].isFacedUp = true
    //            cardsAdded += 1
    //            if cardsAdded >= numberOfCards {
    //                break
    //            }
    //        }
    //    }
        
    //    mutating func shuffle() {
    //        deck = deck.filter { $0.isFacedUp && !$0.isMatched }.shuffled() + deck.filter { !$0.isFacedUp }
    //    }
        
        
        mutating func setCardToFacedUp(_ card: Card) {
            deck.indices.forEach { id in
                if let index = deck.firstIndex(where: { $0.id == card.id }) {
                    deck[index].isFacedUp = true
                }
            }
        }
    
        mutating func toggleFacedUp(_ card: Card) {
//            deck.indices.forEach { id in
//                if let index = deck.firstIndex(where: { $0.id == card.id }) {
//                    deck[index].isFacedUp.toggle()
//                    print("🐸 index \(index)")
//                }
//            }
            
            deck[0].isFacedUp.toggle()
        }
        
    //    mutating func deselect(_ card: Card) {
    //        deck.indices.forEach { id in
    //            if let index = deck.firstIndex(where: { $0.id == card.id }) {
    //                    deck[index].isChosen = false
    //                }
    //            }
    //    }
}
