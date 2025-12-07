//
//  CardView.swift
//  Memorize
//
//  View: Компонент отдельной карты
//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                
                Group {
                    // Лицевая сторона карты
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                    
                    // Фрагмент круговой диаграммы (для красоты)
                    Pie(startAngle: .degrees(-90), endAngle: .degrees(110))
                        .fill(.green.opacity(0.3))
                        .padding(5)
                    
                    // Эмодзи
                    Text(card.content)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.5))
                }
                .opacity(card.isFaceUp ? 1 : 0)
                
                // Обратная сторона карты
                base.fill()
                    .opacity(card.isFaceUp ? 0 : 1)
            }
            .opacity(card.isMatched ? 0 : 1)
            .rotation3DEffect(
                .degrees(card.isFaceUp ? 0 : 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
        }
    }
}

// MARK: - Pie Shape (фрагмент круговой диаграммы)

struct Pie: Shape {
    var startAngle: Angle
    var endAngle: Angle
    var clockwise = false
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let radius = min(rect.width, rect.height) / 2
        let start = CGPoint(
            x: center.x + radius * cos(startAngle.radians),
            y: center.y + radius * sin(startAngle.radians)
        )
        
        var p = Path()
        p.move(to: center)
        p.addLine(to: start)
        p.addArc(
            center: center,
            radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: !clockwise
        )
        p.addLine(to: center)
        return p
    }
}

#Preview {
    VStack {
        HStack {
            CardView(card: MemoryGame<String>.Card(isFaceUp: true, content: "🌸", id: 1))
            CardView(card: MemoryGame<String>.Card(isFaceUp: false, content: "🌸", id: 2))
        }
        HStack {
            CardView(card: MemoryGame<String>.Card(isFaceUp: true, isMatched: true, content: "🌺", id: 3))
            CardView(card: MemoryGame<String>.Card(content: "🌻", id: 4))
        }
    }
    .padding()
}
