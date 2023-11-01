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
    let minimumWidhtOfItem: CGFloat = 80 //if the item size is smaller than a minimumWidhtOfItem: we use a ScrollView
    
    
    init(_ items: [Item], aspectRatio: CGFloat, @ViewBuilder content: @escaping (Item) -> ItemView) {
        self.items = items
        self.aspectRatio = aspectRatio
        self.content = content
    }
    
    var body: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(count: items.count,
                                                     size: geometry.size)
            
                ScrollView() {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: min(gridItemSize, 80)), spacing: 0)], spacing: 0) {
                        ForEach(items) { item in
                            content(item)
                                .aspectRatio(aspectRatio, contentMode: .fit)
                        }
                    }
                }
        }
    }
    
    func gridItemWidthThatFits(
        count: Int,
        size: CGSize
    ) -> CGFloat  {
        let minWithOfCard = 65.0
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return max(CGFloat(minWithOfCard), (size.width / columnCount).rounded(.down))
            }
            columnCount += 1
        } while columnCount < count
        
        let width: CGFloat = floor(size.width / CGFloat(columnCount))
        
        return max(CGFloat(minWithOfCard), width)
    }
    
}
