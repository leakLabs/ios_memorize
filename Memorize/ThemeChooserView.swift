//

import SwiftUI

struct ThemeChooserView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @State private var selectedDifficulty: Difficulty = .easy
    @State private var showingRules = false
    @Environment(\.dismiss) var dismiss
    @Environment(\.verticalSizeClass) var verticalSizeClass
    
    var body: some View {
        NavigationView {
            Group {
                if verticalSizeClass == .compact {
                    landscapeLayout
                } else {
                    portraitLayout
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Закрыть") {
                        dismiss()
                    }
                }
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
        .navigationViewStyle(.stack)
    }
    
    private var portraitLayout: some View {
        VStack(spacing: 25) {
            Text("Выберите тему")
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            difficultySelector
                .padding(.horizontal)
            
            ScrollView {
                themesList
                    .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    private var landscapeLayout: some View {
        HStack(spacing: 0) {
            // Левая панель - сложность
            VStack(spacing: 16) {
                Text("Выберите тему")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Сложность")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                // Вертикальные кнопки сложности
                VStack(spacing: 8) {
                    ForEach(Difficulty.allCases) { difficulty in
                        CompactDifficultyButton(
                            difficulty: difficulty,
                            isSelected: selectedDifficulty == difficulty
                        ) {
                            selectedDifficulty = difficulty
                        }
                    }
                }
                
                Spacer()
            }
            .frame(width: 140)
            .padding()
            .background(Color(.systemGray6))
            
            // Правая часть - темы в виде сетки
            ScrollView {
                LazyVGrid(
                    columns: [
                        GridItem(.flexible(), spacing: 12),
                        GridItem(.flexible(), spacing: 12)
                    ],
                    spacing: 12
                ) {
                    ForEach(Theme.all, id: \.name) { theme in
                        CompactThemeCard(theme: theme, difficulty: selectedDifficulty) {
                            startGame(with: theme)
                        }
                    }
                    
                    CompactRandomThemeCard(difficulty: selectedDifficulty) {
                        let randomTheme = Theme.random(with: selectedDifficulty)
                        startGame(with: randomTheme)
                    }
                }
                .padding()
            }
        }
    }
    
    private var difficultySelector: some View {
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
    }
    
    private var themesList: some View {
        VStack(spacing: 12) {
            ForEach(Theme.all, id: \.name) { theme in
                ThemeCard(theme: theme, difficulty: selectedDifficulty) {
                    startGame(with: theme)
                }
            }
            
            RandomThemeCard(difficulty: selectedDifficulty) {
                let randomTheme = Theme.random(with: selectedDifficulty)
                startGame(with: randomTheme)
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
                Text(theme.emojis.first ?? "🎮")
                    .font(.system(size: 40))
                    .frame(width: 60, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(theme.color.opacity(0.2))
                    )
                
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

struct CompactDifficultyButton: View {
    let difficulty: Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Text("\(difficulty.numberOfPairs)")
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(difficulty.rawValue)
                    .font(.caption)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color.blue : Color.gray.opacity(0.2))
            )
            .foregroundColor(isSelected ? .white : .primary)
        }
    }
}

struct CompactThemeCard: View {
    let theme: Theme
    let difficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(theme.emojis.first ?? "🎮")
                    .font(.system(size: 36))
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(theme.color.opacity(0.2))
                    )
                
                Text(theme.name)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("\(difficulty.numberOfPairs) пар")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(theme.color, lineWidth: 2)
            )
        }
    }
}

struct CompactRandomThemeCard: View {
    let difficulty: Difficulty
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "shuffle")
                    .font(.system(size: 28))
                    .frame(width: 50, height: 50)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.purple.opacity(0.2))
                    )
                    .foregroundColor(.purple)
                
                Text("Случайная")
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Text("Сюрприз!")
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.purple, lineWidth: 2)
            )
        }
    }
}
