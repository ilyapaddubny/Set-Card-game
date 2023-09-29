//
//  GameViewModel.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import Foundation

class GameSetViewModel: ObservableObject {
    @Published var gameModel = SetModel()
    
    var cards: [SetModel.Card] {
        gameModel.deck
    }
    
    // MARK: - Intents
    
    func choose(_ card: SetModel.Card) -> Void {
        
    }
    
    func shuffle() -> Void {
        gameModel.shuffle()
    }
    
}
