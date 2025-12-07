//

import SwiftUI

struct EmojiMemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State private var showingThemeChooser = false
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    private let aspectRatio: CGFloat = 2/3
    
    var body: some View {
        GeometryReader { geometry in
            if verticalSizeClass == .compact {
                landscapeLayout
            } else {
                portraitLayout
            }
        }
        .background(viewModel.theme.color.opacity(0.1))
        .alert("Игра завершена! 🎉", isPresented: $viewModel.isGameCompleted) {
            Button("Новая игра") {
                viewModel.newGame(with: viewModel.theme)
            }
            Button("Выбрать тему") {
                showingThemeChooser = true
            }
        } message: {
            Text("Ваш счёт: \(viewModel.score)\nВы нашли все пары!")
        }
        .sheet(isPresented: $showingThemeChooser) {
            ThemeChooserView(viewModel: viewModel)
        }
    }
    
    private var portraitLayout: some View {
        VStack(spacing: 0) {
            // Шапка с заголовком и счетом
            header
                .padding(.horizontal)
                .padding(.top)
            
            Spacer(minLength: 0)
            
            // Сетка с картами
            cards
                .padding(.horizontal, 8)
            
            Spacer(minLength: 0)
            
            // Кнопки управления
            controlButtons
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
    
    private var landscapeLayout: some View {
        HStack(spacing: 0) {
            cards
                .padding(8)
            
            VStack(spacing: 20) {
                header
                Spacer()
                VStack(spacing: 15) {
                    chooseThemeButton
                    newGameButton
                    shuffleButton
                    hintButton
                }
                Spacer()
            }
            .frame(maxWidth: 200)
            .padding()
        }
    }
    
    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Memorize")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Spacer()
                
                Text(viewModel.theme.name)
                    .font(.headline)
                    .foregroundColor(viewModel.theme.color)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(
                        Capsule()
                            .fill(viewModel.theme.color.opacity(0.2))
                    )
            }
            
            HStack {
                Text("Счет:")
                    .font(.title2)
                    .fontWeight(.semibold)
                Text("\(viewModel.score)")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(viewModel.theme.color)
                    .monospacedDigit()
            }
        }
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
                    CardView(
                        card: card,
                        theme: viewModel.theme,
                        forceShowFaceUp: viewModel.isShowingHint
                    )
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
    
    private var controlButtons: some View {
        HStack(spacing: 20) {
            chooseThemeButton
            newGameButton
            shuffleButton
            hintButton
        }
    }
    
    private var chooseThemeButton: some View {
        Button(action: {
            showingThemeChooser = true
        }) {
            VStack(spacing: 5) {
                Image(systemName: "paintbrush.fill")
                    .font(.system(size: 30))
                Text("Theme")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(viewModel.theme.color)
        }
    }
    
    private var newGameButton: some View {
        Button(action: {
            withAnimation {
                viewModel.newGame(with: viewModel.theme)
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
    
    private var hintButton: some View {
        Button(action: {
            withAnimation {
                viewModel.useHint()
            }
        }) {
            VStack(spacing: 5) {
                ZStack {
                    Image(systemName: "lightbulb.circle.fill")
                        .font(.system(size: 30))
                    
                    if viewModel.hintsRemaining > 0 {
                        Text("\(viewModel.hintsRemaining)")
                            .font(.caption2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .offset(x: 10, y: -10)
                    }
                }
                Text("Hint")
                    .font(.caption)
                    .fontWeight(.semibold)
            }
            .foregroundColor(viewModel.hintsRemaining > 0 ? viewModel.theme.color : .gray)
        }
        .disabled(viewModel.hintsRemaining == 0)
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
