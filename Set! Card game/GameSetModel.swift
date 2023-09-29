//
//  SetModel.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import Foundation


                    

struct GameSetModel {
    private(set) var deck = [Card]()
    
    init() {
        createTheDeck()
        print(deck.count)
    }
    
    //iterates over all the possible cards and append them to the deck
    mutating func createTheDeck() {
        
       
        for colorCases in FillType.allCases {
            let color = colorCases.color
            
            for fillTypeCases in FillType.allCases {
                let fillType = fillTypeCases.fillType
                
                for shapeCases in FillType.allCases {
                    let shape = shapeCases.shape
                    
                    for numberOfItemsCases in FillType.allCases {
                        let numberOfItems = numberOfItemsCases.numberOfItems
                        
                        deck.append(Card(color: color, numberOfItems: numberOfItems, shape: shape, fillType: fillType))
                    }
                }
            }
        }
    }
    
    mutating func shuffle() {
        deck.shuffle()
    }

    
    struct Card: Identifiable {
        let color: String
        let numberOfItems: Int
        let shape: String
        let fillType: String
        
        var id = UUID()
        
        var isMatched = false
        var isChosen = false
    }
    
    enum FillType: CaseIterable {
        case one, two, three
        
        var color: String {
            switch self {
            case .one: "Red"
            case .two: "Green"
            case .three: "Blue"
            }
        }
        var fillType: String {
            switch self {
            case .one: "Empty"
            case .two: "Striped"
            case .three: "Solid"
            }
        }
        var shape: String {
            switch self {
            case .one: "Squere"
            case .two:  "Circle"
            case .three: "Rectangle"
            }
        }
        var numberOfItems: Int {
            switch self {
            case .one: 1
            case .two: 2
            case .three: 3
            }
        }
    }
}
