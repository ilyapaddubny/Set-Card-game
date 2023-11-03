//
//  ShapeView.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.10.2023.
//

import SwiftUI

struct ShapeView: View {
    let card: GameSetModel<CardContent>.Card
    
    private let contentPadding: CGFloat = 4
    private let cardAspectRatio: CGFloat = 2/3
    private let shapeAspectRatio: CGFloat = 2/1
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                ForEach(0..<card.content.numberOfItems, id: \.self) {index in
                    shape(size: geometry.size, index: index)
                        .padding([.top, .bottom], contentPadding/2)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
        }
    }
    
    
    @ViewBuilder
    func shape(size: CGSize, index: Int) -> some View {
        switch card.content.shape {
        case .circle:
            ZStack {
                Circle()
                    .stroke(lineWidth: card.content.opacity == OneOfThree.one.opacity ?  3 : 1)
                    .foregroundColor(card.content.opacity == OneOfThree.one.opacity ? card.content.color : .black)
                    .frame(height: max(size.height/3-contentPadding, 0))
                Circle()
                    .foregroundColor(card.content.color)
                    .opacity(card.content.opacity)
                    .frame(height: max(size.height/3-contentPadding, 0))
            }
            
        case .diamond:
            ZStack {
                DiamondShape()
                    .stroke(lineWidth: card.content.opacity == OneOfThree.one.opacity ?  3 : 1)
                    .foregroundColor(card.content.opacity == OneOfThree.one.opacity ? card.content.color : .black)
                    .frame(height: max(size.height/3-contentPadding, 0))
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
                
                DiamondShape()
                    .foregroundColor(card.content.color)
                    .opacity(card.content.opacity)
                    .frame(height: max(size.height/3-contentPadding, 0))
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
            }
            
        case.wavedShape:
            ZStack {
                WavedShape()
                    .stroke(lineWidth: card.content.opacity == OneOfThree.one.opacity ?  3 : 1)
                    .foregroundColor(card.content.opacity == OneOfThree.one.opacity ? card.content.color : .black)
                    .frame(height: max(size.height/3-contentPadding, 0))
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
                
                WavedShape()
                    .foregroundColor(card.content.color)
                    .opacity(card.content.opacity)
                    .frame(height: max(size.height/3-contentPadding, 0))
                    .aspectRatio(shapeAspectRatio, contentMode: .fit)
                
            }
        }
    }
}

