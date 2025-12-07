//

import SwiftUI

struct GameRulesView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    Text("Правила игры")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top)
                    
                    RuleSection(title: "🎯 Цель игры") {
                        Text("Найдите все пары одинаковых карт. Открывайте по две карты за раз и запоминайте их расположение.")
                            .foregroundColor(.secondary)
                    }
                    
                    RuleSection(title: "🎮 Как играть") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("1. Нажмите на карту, чтобы перевернуть её")
                            Text("2. Нажмите на вторую карту")
                            Text("3. Если карты совпадают - они исчезнут")
                            Text("4. Если не совпадают - запомните их")
                            Text("5. Продолжайте, пока не найдёте все пары")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    RuleSection(title: "⭐ Система очков") {
                        VStack(alignment: .leading, spacing: 8) {
                            HStack {
                                Text("✅ +2")
                                    .fontWeight(.bold)
                                    .foregroundColor(.green)
                                Text("За каждое совпадение")
                            }
                            HStack {
                                Text("❌ -1")
                                    .fontWeight(.bold)
                                    .foregroundColor(.red)
                                Text("За ошибку с ранее увиденной картой")
                            }
                            HStack {
                                Text("💡 -5")
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                Text("За использование подсказки")
                            }
                        }
                        .font(.subheadline)
                    }
                    
                    RuleSection(title: "💡 Подсказка") {
                        Text("У вас есть одна подсказка на игру. При использовании все карты переворачиваются на 1 секунду. Штраф: 5 очков.")
                            .foregroundColor(.secondary)
                    }
                    
                    RuleSection(title: "🎛 Кнопки") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Theme - выбор темы оформления")
                            Text("• New Game - начать новую игру")
                            Text("• Shuffle - перемешать карты")
                            Text("• Hint - показать подсказку")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    RuleSection(title: "🎨 Темы") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Цветы 🌸 (зеленая)")
                            Text("• Животные 🐶 (оранжевая)")
                            Text("• Еда 🍎 (красная)")
                            Text("• Случайная тема")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    RuleSection(title: "📊 Сложность") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Легко - 8 пар (16 карт)")
                            Text("• Средне - 12 пар (24 карты)")
                            Text("• Сложно - 24 пары (48 карт)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    RuleSection(title: "💭 Советы") {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("• Концентрируйтесь на запоминании")
                            Text("• Не открывайте карты наугад")
                            Text("• Используйте подсказку в нужный момент")
                            Text("• Чем меньше ошибок - тем выше счёт")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    
                    Spacer(minLength: 20)
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Назад") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct RuleSection<Content: View>: View {
    let title: String
    let content: () -> Content
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
            
            content()
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
    }
}
