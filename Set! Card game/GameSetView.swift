//
//  ContentView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import SwiftUI

struct GameSetView: View {
    @StateObject var viewModel = GameSetViewModel()
    private let cardAspectRatio: CGFloat = 2/3
    var body: some View {
        VStack {
            Text("Set").font(.title)
            cards
                .animation(.default, value: viewModel.cards)
            buttonsSection
        }
        .padding()
    }
    
    //    set of cards
    @ViewBuilder
    private var cards: some View {
        AspectVGrid(viewModel.cards.filter({$0.onTheTable}), aspectRatio: cardAspectRatio) { card in
            CardView(card)
                .padding(4)
                .onTapGesture {
                    viewModel.choose(card)
                }
        }
        
    }
    
    var buttonsSection: some View {
        HStack {
            Button {
                if viewModel.setSelected() {
                    viewModel.replaceMachedCards()
                } else {
                    viewModel.addThreeMoreCards()
                }
            } label: {
                Text("Deal 3 More Cards")
                    .font(.title2)
                    .foregroundStyle(.white)
                    .padding(8)
                    .background {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(.blue)
                    }
            }.disabled(viewModel.cards.filter{!$0.onTheTable}.count == 0)
            
            Button {
                viewModel.newGame()
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
    }
}

#Preview {
    GameSetView()
}
