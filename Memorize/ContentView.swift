//
//  ContentView.swift
//  Memorize
//
//  Главный экран с навигацией
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        EmojiMemoryGameView(viewModel: viewModel)
    }
}

#Preview {
    ContentView(viewModel: EmojiMemoryGame())
}
