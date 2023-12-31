//
//  GameViewModel.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import Foundation
import SwiftUI

class GameSetViewModel: ObservableObject {
    typealias Card = GameSetModel<CardContent>.Card
    
    private static let contentArray: [Text] = Array(repeating: Text("1"), count: 81)
    private static var contentArrayShape = [CardContent]()
    
    private static func fetchContentArray() {
        contentArrayShape = [CardContent]()
        for colorCases in OneOfThree.allCases {
            let colorName = colorCases.colorName
            
            for fillTypeCases in OneOfThree.allCases {
                let opacityType = fillTypeCases.opacity
                
                for shapeCases in OneOfThree.allCases {
                    let shape = shapeCases.shape
                    
                    for numberOfItemsCases in OneOfThree.allCases {
                        let numberOfItems = numberOfItemsCases.numberOfItems
                        
                        let content = CardContent(colorName: colorName, opacity: opacityType, shape: shape, numberOfItems: numberOfItems)
                        contentArrayShape.append(content)
                    }
                }
            }
        }
    }
    
    private static func createGame() -> GameSetModel<CardContent> {
        fetchContentArray()
        return GameSetModel(numberOfCards: contentArrayShape.count) { index in
            if contentArrayShape.indices.contains(index){
                contentArrayShape[index]
            } else {
                CardContent(colorName: "blue", opacity: 0, shape: .diamond, numberOfItems: 1)
            }
        }
        
    }
    
    @Published private var gameModel = createGame()
    
    var card: [Card] {
        gameModel.testCards
    }
    
    func test() {
        gameModel.test()
    }
    
    var cards: [Card] {
        gameModel.deck
    }
    
    var threeCardsSelected: Bool {
        cards.filter{$0.isChosen}.count == 3
    }
    
    func setCardToFacedUp(_ card: Card) {
        gameModel.setCardToFacedUp(card)
    }
    func toggleFacedUp(_ card: Card) {
        gameModel.toggleFacedUp(card)
    }
    
//     func deselect(_ card: Card) {
//        gameModel.deselect(card)
//    }
    
    var faceUpCards: [Card] {
        return gameModel.deck.filter({$0.isFacedUp})
    }
    
     func drawCard() {
         gameModel.drawNamberOfCards(1)
    }
    
    
    
    
    // MARK: - Intents
    
    func choose(_ card: Card) -> Void {
        withAnimation {
            gameModel.choose(card) {cards in
                //Set logic
                let opacityCheck = (cards[0].content.opacity == cards[1].content.opacity && cards[1].content.opacity == cards[2].content.opacity) ||
                (cards[0].content.opacity != cards[1].content.opacity && cards[1].content.opacity != cards[2].content.opacity  && cards[0].content.opacity != cards[2].content.opacity)
                
                let numberOfItemsCheck = (cards[0].content.numberOfItems == cards[1].content.numberOfItems && cards[1].content.numberOfItems == cards[2].content.numberOfItems) ||  (cards[0].content.numberOfItems != cards[1].content.numberOfItems && cards[1].content.numberOfItems != cards[2].content.numberOfItems  && cards[0].content.numberOfItems != cards[2].content.numberOfItems)
                
                let shapeCheck = (cards[0].content.shape == cards[1].content.shape && cards[1].content.shape == cards[2].content.shape) || (cards[0].content.shape != cards[1].content.shape && cards[1].content.shape != cards[2].content.shape  && cards[0].content.shape != cards[2].content.shape)
                
                let colorCheck = (cards[0].content.colorName == cards[1].content.colorName && cards[1].content.colorName == cards[2].content.colorName) || (cards[0].content.colorName != cards[1].content.colorName && cards[1].content.colorName != cards[2].content.colorName  && cards[0].content.colorName != cards[2].content.colorName)
                
                return opacityCheck && numberOfItemsCheck && shapeCheck && colorCheck
            }
        }
        
        
    }
    
    
//    func shuffle() -> Void {gameModel.shuffle()}
    
    func newGame() {gameModel.newGame()}
}

enum OneOfThree: CaseIterable {
    case one, two, three
    
    var colorName: String {
        switch self {
        case .one: "red"
        case .two: "blue"
        case .three: "green"
        }
    }
    var opacity: Double {
        switch self {
        case .one: 0.0
        case .two: 0.4
        case .three: 1
        }
    }
    var shape: CardContent.ShapeType {
        switch self {
        case .one: CardContent.ShapeType.circle
        case .two: CardContent.ShapeType.diamond
        case .three: CardContent.ShapeType.wavedShape
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

    extension CardContent {
        var color: Color {
            get {
                switch colorName {
                case "red":
                    Color.red
                case "blue":
                    Color.blue
                case "green":
                    Color.green
                default:
                    Color.black
                }
            }
        }
    }

