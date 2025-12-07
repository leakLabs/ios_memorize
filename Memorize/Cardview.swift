//

import SwiftUI

struct CardView: View {
    let card: MemoryGame<String>.Card
    let theme: Theme
    var forceShowFaceUp: Bool = false
    
    private var shouldShowFaceUp: Bool {
        card.isFaceUp || forceShowFaceUp
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let base = RoundedRectangle(cornerRadius: 12)
                
                Group {
                    base.fill(.white)
                    base.strokeBorder(lineWidth: 2)
                        .foregroundColor(theme.color)
                    
                    Pie(startAngle: theme.pieStartAngle, endAngle: theme.pieEndAngle)
                        .fill(theme.color.opacity(0.3))
                        .padding(5)
                    
                    Text(card.content)
                        .font(.system(size: min(geometry.size.width, geometry.size.height) * 0.5))
                }
                .opacity(shouldShowFaceUp ? 1 : 0)
                
                base.fill(theme.cardBackColor)
                                    .opacity(shouldShowFaceUp ? 0 : 1)
            }
            .opacity(card.isMatched ? 0 : 1)
            .rotation3DEffect(
                .degrees(shouldShowFaceUp ? 0 : 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
            )
        }
    }
}

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
