//
//  MemoryGame.swift
//  Memorize
//
//  Model: Логика игры
//

import Foundation

struct MemoryGame<CardContent> where CardContent: Equatable {
    private(set) var cards: Array<Card>
    private(set) var score: Int = 0
    private var seenCards: Set<Int> = []
    
    private var indexOfTheOneAndOnlyFaceUpCard: Int? {
        get { cards.indices.filter { cards[$0].isFaceUp }.only }
        set { cards.indices.forEach { cards[$0].isFaceUp = ($0 == newValue) } }
    }
    
    init(numberOfPairsOfCards: Int, cardContentFactory: (Int) -> CardContent) {
        cards = []
        // Создаем пары карт
        for pairIndex in 0..<numberOfPairsOfCards {
            let content = cardContentFactory(pairIndex)
            cards.append(Card(content: content, id: pairIndex * 2))
            cards.append(Card(content: content, id: pairIndex * 2 + 1))
        }
        cards.shuffle()
    }
    
    mutating func choose(_ card: Card) {
        if let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
           !cards[chosenIndex].isFaceUp,
           !cards[chosenIndex].isMatched {
            
            if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                // Уже есть одна открытая карта, проверяем совпадение
                cards[chosenIndex].isFaceUp = true
                
                if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                    // Совпадение - добавляем 2 очка
                    // Исчезновение будет с задержкой через markMatchedCards()
                    score += 2
                } else {
                    // Несовпадение - проверяем штрафы за ранее увиденные карты
                    if seenCards.contains(cards[chosenIndex].id) {
                        score -= 1
                    }
                    if seenCards.contains(cards[potentialMatchIndex].id) {
                        score -= 1
                    }
                }
                // Отмечаем карты как увиденные
                seenCards.insert(cards[chosenIndex].id)
                seenCards.insert(cards[potentialMatchIndex].id)
            } else {
                // Либо нет открытых карт, либо больше одной - переворачиваем все
                indexOfTheOneAndOnlyFaceUpCard = chosenIndex
            }
        }
    }
    
    mutating func markMatchedCards() {
        // Помечаем совпавшие карты как matched (вызывается с задержкой)
        let faceUpCards = cards.filter { $0.isFaceUp && !$0.isMatched }
        
        if faceUpCards.count == 2 {
            if faceUpCards[0].content == faceUpCards[1].content {
                // Карты совпали - помечаем обе
                for index in cards.indices {
                    if cards[index].id == faceUpCards[0].id || cards[index].id == faceUpCards[1].id {
                        cards[index].isMatched = true
                    }
                }
            }
        }
    }
    
    var isGameCompleted: Bool {
        cards.allSatisfy { $0.isMatched }
    }
    
    mutating func shuffle() {
        cards.shuffle()
    }
    
    mutating func applyHintPenalty() {
        score -= 5
    }
    
    struct Card: Identifiable {
        var isFaceUp = false
        var isMatched = false
        let content: CardContent
        let id: Int
    }
}

extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
