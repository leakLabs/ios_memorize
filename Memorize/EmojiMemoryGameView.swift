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
                landscapeLayout(in: geometry.size)
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
            header
                .padding(.horizontal)
                .padding(.top)
            
            Spacer(minLength: 0)
            
            cards
                .padding(.horizontal, 8)
            
            Spacer(minLength: 0)
            
            controlButtons
                .padding(.horizontal)
                .padding(.bottom, 20)
        }
    }
    
    private func landscapeLayout(in size: CGSize) -> some View {
        let sidebarWidth: CGFloat = min(160, size.width * 0.22)
        let cardsWidth = size.width - sidebarWidth - 16
        
        return HStack(spacing: 8) {
            // Карты слева
            cards(in: CGSize(width: cardsWidth, height: size.height))
                .frame(width: cardsWidth)
                .padding(.leading, 8)
                .padding(.vertical, 8)
            
            // Компактная боковая панель справа
            VStack(spacing: 0) {
                // Компактный заголовок
                VStack(spacing: 4) {
                    Text(viewModel.theme.name)
                        .font(.subheadline)
                        .fontWeight(.semibold)
                        .foregroundColor(viewModel.theme.color)
                        .lineLimit(1)
                    
                    HStack(spacing: 4) {
                        Text("Счёт:")
                            .font(.caption)
                        Text("\(viewModel.score)")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.theme.color)
                            .monospacedDigit()
                    }
                }
                .padding(.top, 8)
                
                Spacer()
                
                // Компактные кнопки в виде сетки 2x2
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    compactButton(
                        icon: "paintbrush.fill",
                        label: "Тема",
                        color: viewModel.theme.color
                    ) {
                        showingThemeChooser = true
                    }
                    
                    compactButton(
                        icon: "plus.circle.fill",
                        label: "Новая игра",
                        color: .blue
                    ) {
                        withAnimation {
                            viewModel.newGame(with: viewModel.theme)
                        }
                    }
                    
                    compactButton(
                        icon: "shuffle.circle.fill",
                        label: "Перемешать",
                        color: .orange
                    ) {
                        withAnimation {
                            viewModel.shuffle()
                        }
                    }
                    
                    compactHintButton
                }
                .padding(.horizontal, 8)
                
                Spacer()
            }
            .frame(width: sidebarWidth)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color(.systemBackground).opacity(0.8))
            )
            .padding(.trailing, 8)
            .padding(.vertical, 8)
        }
    }
    
    private func compactButton(
        icon: String,
        label: String,
        color: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 2) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                Text(label)
                    .font(.system(size: 9))
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
    }
    
    private var compactHintButton: some View {
        Button(action: {
            withAnimation {
                viewModel.useHint()
            }
        }) {
            VStack(spacing: 2) {
                Image(systemName: "lightbulb.circle.fill")
                    .font(.system(size: 22))
                
                Text("Подсказка")
                    .font(.system(size: 9))
                    .fontWeight(.medium)
            }
            .foregroundColor(viewModel.hintsRemaining > 0 ? viewModel.theme.color : .gray)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 6)
        }
        .disabled(viewModel.hintsRemaining == 0)
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
    
    // Версия для portraitLayout
    private var cards: some View {
        GeometryReader { geometry in
            cardsGrid(in: geometry.size)
        }
    }
    
    // Версия для landscapeLayout
    private func cards(in size: CGSize) -> some View {
        cardsGrid(in: size)
    }
    
    private func cardsGrid(in size: CGSize) -> some View {
        let gridItemSize = gridItemWidthThatFits(
            count: viewModel.cards.count,
            in: size,
            aspectRatio: aspectRatio
        )
        
        return LazyVGrid(
            columns: [GridItem(.adaptive(minimum: gridItemSize), spacing: 0)],
            spacing: 0
        ) {
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
                    .font(.system(size: 25))
                Text("Тема")
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
                Text("Новая игра")
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
                Text("Перемешать")
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
                Image(systemName: "lightbulb.circle.fill")
                    .font(.system(size: 30))
                Text("Подсказка")
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
