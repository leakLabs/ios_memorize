//
//  EmojiMemoryGameView.swift
//  Memorize
//
//  View: Пользовательский интерфейс игры
//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        VStack {
            Text("Memorize")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top)
            
            Spacer()
            
            // Сетка с картами
            cards
            
            Spacer()
            
            // Кнопки управления
            HStack(spacing: 40) {
                newGameButton
                shuffleButton
            }
            .padding(.bottom, 30)
        }
        .padding()
    }
    
    private var cards: some View {
        GeometryReader { geometry in
            let gridItemSize = gridItemWidthThatFits(
                count: viewModel.cards.count,
                in: geometry.size,
                aspectRatio: aspectRatio
            )
            
            LazyVGrid(columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)], spacing: 0) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .aspectRatio(aspectRatio, contentMode: .fit)
                        .padding(4)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                viewModel.choose(card)
                            }
                        }
                }
            }
        }
    }
    
    private var newGameButton: some View {
        Button(action: {
            withAnimation {
                viewModel.newGame()
            }
        }) {
            VStack(spacing: 5) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30))
                Text("New Game")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.blue)
        }
    }
    
    private var shuffleButton: some View {
        Button(action: {
            withAnimation {
                viewModel.shuffle()
            }
        }) {
            VStack(spacing: 5) {
                Image(systemName: "shuffle.circle.fill")
                    .font(.system(size: 30))
                Text("Shuffle")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(.orange)
        }
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        in size: CGSize,
        aspectRatio: CGFloat
    ) -> CGFloat {
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

#Preview {
    EmojiMemoryGameView(viewModel: EmojiMemoryGame())
}
