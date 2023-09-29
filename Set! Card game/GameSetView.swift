//
//  ContentView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import SwiftUI

struct GameSetView: View {
    @StateObject var viewModel = SetViewModel()
    
    var body: some View {
        VStack {
            cards
        }
        .padding()
    }
    
    
    var cards: some View {
        ForEach(viewModel.cards) { card in
            Text(card.color)
        }
    }
}



#Preview {
    GameSetView()
}
