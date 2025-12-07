//
//  EmojiMemoryGame.swift
//  Memorize
//
//  ViewModel: Связь между Model и View
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    private static let emojis = ["🌸", "🌺", "🌻", "🌼", "🌷", "🌹", "🏵️", "💐", "🌿", "🍀"]
    
    @Published private var model: MemoryGame<String>
    
    init() {
        // Случайное количество пар от 2 до 5
        let numberOfPairs = Int.random(in: 2...5)
        model = EmojiMemoryGame.createMemoryGame(numberOfPairs: numberOfPairs)
    }
    
    private static func createMemoryGame(numberOfPairs: Int) -> MemoryGame<String> {
        let shuffledEmojis = emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: numberOfPairs) { pairIndex in
            if pairIndex < shuffledEmojis.count {
                return shuffledEmojis[pairIndex]
            } else {
                return "⁉️"
            }
        }
    }
    
    var cards: Array<MemoryGame<String>.Card> {
        model.cards
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame() {
        let numberOfPairs = Int.random(in: 2...5)
        model = EmojiMemoryGame.createMemoryGame(numberOfPairs: numberOfPairs)
    }
}
