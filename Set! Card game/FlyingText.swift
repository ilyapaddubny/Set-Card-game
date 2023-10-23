//
//  FlyingText.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 23.10.2023.
//

import SwiftUI

struct FlyingText: View {
    var isSet: Bool
    @State private var offset: CGFloat = 0
    
    var body: some View {
        let setText = "Set!"
        if isSet {
            Text(setText)
                .font(.largeTitle)
                .foregroundStyle(Color.green)
                .shadow(color: .black, radius: 1, x: 0.5, y: 0.5)
                .offset(x:0, y: offset)
                .opacity(offset != 0 ? 0 : 1)
                .onAppear {
                    withAnimation(.easeIn(duration: 1)) {
                        offset = isSet ? -200 : 0
                    }
                }
                .onDisappear {
                    offset = 0
                }
        }
    }
}

#Preview {
    FlyingText(isSet: true)
}
