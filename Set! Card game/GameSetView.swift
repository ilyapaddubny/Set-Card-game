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
            addCardsButton
        }
        .padding()
    }
    
    
    //    set of cards
    private var cards: some View {
        AspectVGrid(viewModel.cards.filter({
            $0.onTheTable
        }), aspectRatio: cardAspectRatio) { card in
            if card.onTheTable == true {
                CardView(card)
                    .padding(4)
                    .onTapGesture {
                        viewModel.choose(card)
                        viewModel.shuffle()
                    }
            }
        }
    }
    
    
    var addCardsButton: some View {
        Button {
            viewModel.addThreeMoreCards()
        } label: {
            Text("ADD CARDS")
                .font(.title2)
                .foregroundStyle(.white)
                .padding(4)
                .background {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(.blue)
                }
        }
        
    }
    
}



struct CardView: View {
    let card: GameSetModel<CardContent>.Card
    private let shapeAspectRatio: CGFloat = 2/1
    let base = RoundedRectangle(cornerRadius: 12)

    init(_ card: GameSetModel<CardContent>.Card) {
        self.card = card
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            base.stroke().foregroundColor(.gray)
            base.fill(.white)
            content
                            .padding()
                .minimumScaleFactor(0.1)
                .aspectRatio(2/3, contentMode: .fill)
        }
    }
    
    //    creates needed number of shapes
    @ViewBuilder
    var content: some View {
        let numberOfShapes = 0..<card.content.numberOfItems
            GeometryReader {geometry in
                VStack(alignment: .center, spacing: 0) {
                    ForEach(numberOfShapes) {_ in
                        shape(geometry: geometry)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
//                .background(.yellow)
            }
    }
    
    //    shape dreation
    @ViewBuilder
    func shape(geometry: GeometryProxy) -> some View {
            switch card.content.shape {
            case .circle:
                ZStack {
                    Circle()
                        .stroke()
                        .foregroundColor(.black)
                        .frame(height: geometry.size.height/3)
                    Circle()
                        .foregroundColor(card.content.color)
                        .opacity(card.content.opacity)
                        .frame(height: geometry.size.height/3)
//                        .background(.gray)
                }
                
            case .ellipse:
                ZStack {
                    Ellipse()
                        .stroke()
                        .foregroundColor(.black)
                        .frame(height: geometry.size.height/3)
                        .aspectRatio(shapeAspectRatio, contentMode: .fit)
                    
                    Ellipse()
                        .foregroundColor(card.content.color)
                        .opacity(card.content.opacity)
                        .frame(height: geometry.size.height/3)
                        .aspectRatio(shapeAspectRatio, contentMode: .fit)
//                        .background(.gray)

                    
                }
                
            case.roundedRectangle(let cornerRadius):
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .stroke()
                        .foregroundColor(.black)
                        .frame(height: geometry.size.height/3)
                        .aspectRatio(shapeAspectRatio, contentMode: .fit)
                    
                    RoundedRectangle(cornerRadius: cornerRadius)
                        .foregroundColor(card.content.color)
                        .opacity(card.content.opacity)
                        .frame(height: geometry.size.height/3)
                        .aspectRatio(shapeAspectRatio, contentMode: .fit)
//                        .background(.gray)

                    
                }
            
        }
        
    }
    
}



#Preview {
    GameSetView()
}
