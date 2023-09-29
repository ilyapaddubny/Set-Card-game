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
        addNumberOfCards(9)
    }
    
    mutating func shuffle() {
        deck.shuffle()
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

    
    struct Card: Identifiable, Equatable {
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
        var onTheTable = false
    }
}
