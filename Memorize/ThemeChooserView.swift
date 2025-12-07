//

import SwiftUI

struct ThemeChooserView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showingRules = false
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 25) {
                // Заголовок
                Text("Выберите тему")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                // Выбор сложности
                VStack(alignment: .leading, spacing: 10) {
                    Text("Сложность")
                        .font(.headline)
                    
                    HStack(spacing: 10) {
                        ForEach(Difficulty.allCases) { difficulty in
                            DifficultyButton(
                                difficulty: difficulty,
                                isSelected: selectedDifficulty == difficulty
                            ) {
                                selectedDifficulty = difficulty
                            }
                        }
                    }
                }
                .padding(.horizontal)
                
                // Список тем
                VStack(spacing: 12) {
                    ForEach(Theme.all, id: \.name) { theme in
                        ThemeCard(theme: theme, difficulty: selectedDifficulty) {
                            startGame(with: theme)
                        }
                    }
                    
                    // Случайная тема
                    RandomThemeCard(difficulty: selectedDifficulty) {
                        let randomTheme = Theme.random(with: selectedDifficulty)
                        startGame(with: randomTheme)
                    }
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Правила") {
                        showingRules = true
                    }
                }
            }
            .sheet(isPresented: $showingRules) {
                GameRulesView()
            }
        }
    }
    
    private func startGame(with theme: Theme) {
        var selectedTheme = theme
        selectedTheme.setDifficulty(selectedDifficulty)
        viewModel.newGame(with: selectedTheme)
        dismiss()
    }
}

struct DifficultyButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 5) {
                Text("\(difficulty.numberOfPairs)")
                    .font(.title3)
                    .fontWeight(.bold)
                Text(difficulty.rawValue)
                    .font(.caption)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct ThemeCard: View {
    let theme: Theme
    let difficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                // Иконка темы
                Text(theme.emojis.first ?? "🎮")
                    .font(.system(size: 40))
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(theme.color.opacity(0.2))
                    )
                
                // Информация о теме
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("\(difficulty.numberOfPairs) пар карт")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(theme.color, lineWidth: 2)
            )
        }
    }
}

struct RandomThemeCard: View {
    let difficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "shuffle")
                    .font(.system(size: 30))
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.purple.opacity(0.2))
                    )
                    .foregroundColor(.purple)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Случайная тема")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text("Сюрприз!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.purple, lineWidth: 2)
            )
        }
    }
}
