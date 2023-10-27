//
//  Set__Card_gameApp.swift
//  Set! Card game
//
//  Created by Ilya Paddubny on 27.09.2023.
//

import SwiftUI

@main
struct Set__Card_gameApp: App {
    var body: some Scene {
        WindowGroup {
            let game = GameSetViewModel()
            GameSetView(viewModel: game)
        }
    }
}
