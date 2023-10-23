//
//  AspectVGrid.swift
//  Memorize
//
//  Created by CS193p Instructor on 4/24/23.
//

import SwiftUI

struct AspectVGrid<Item: Identifiable, ItemView: View>: View {
    let items: [Item]
    var aspectRatio: CGFloat = 1
    let content: (Item) -> ItemView
    let minimumWidhtOfItem: CGFloat = 65 //if the item size is smaller than a minimumWidhtOfItem: we use a ScrollView
    
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: items.count,
                size: geometry.size,
                atAspectRatio: aspectRatio
            )
            
            
            if (gridItemSize < minimumWidhtOfItem) {
                ScrollView() {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 65), spacing: 0)], spacing: 0) {
                        ForEach(items) { item in
                            content(item)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
                .transition(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
            } else {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                    ForEach(items) { item in
                        content(item)
                            .aspectRatio(aspectRatio, contentMode: .fit)
                    }
                }
                .transition(/*@START_MENU_TOKEN@*/.identity/*@END_MENU_TOKEN@*/)
            }
        }
    }
    
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat  {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.down)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
    
}
