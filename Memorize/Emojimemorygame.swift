//
//  EmojiMemoryGame.swift
//  Memorize
//
//  ViewModel: Связь между Model и View
//

import SwiftUI

class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    @Published private(set) var theme: Theme
    @Published private(set) var hintsRemaining: Int = 1
    @Published var isShowingHint: Bool = false
    @Published var isGameCompleted: Bool = false
    
    init(theme: Theme = Theme.flowers) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
    }
    
    private static func createMemoryGame(theme: Theme) -> MemoryGame<String> {
        let shuffledEmojis = theme.emojis.shuffled()
        return MemoryGame<String>(numberOfPairsOfCards: theme.numberOfPairs) { pairIndex in
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
    
    var score: Int {
        model.score
    }
    
    // MARK: - Intents
    
    func choose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        
        // Задержка перед исчезновением совпавших карт
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.model.markMatchedCards()
            
            // Проверяем завершение игры
            if self.model.isGameCompleted {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.isGameCompleted = true
                }
            }
        }
    }
    
    func shuffle() {
        model.shuffle()
    }
    
    func newGame(with theme: Theme) {
        self.theme = theme
        model = EmojiMemoryGame.createMemoryGame(theme: theme)
        hintsRemaining = 1
        isShowingHint = false
        isGameCompleted = false
    }
    
    func useHint() {
        guard hintsRemaining > 0 else { return }
        
        hintsRemaining -= 1
        model.applyHintPenalty()
        
        // Показываем все карты
        isShowingHint = true
        
        // Через 1 секунду скрываем
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.isShowingHint = false
        }
    }
}
