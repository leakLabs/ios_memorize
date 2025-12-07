//

import SwiftUI

struct Theme {
    let name: String
    let emojis: [String]
    var numberOfPairs: Int
    let color: Color
    let cardBackColor: Color
    let pieStartAngle: Angle
    let pieEndAngle: Angle
    
    static let flowers = Theme(
        name: "Цветы",
        emojis: ["🌸", "🌺", "🌻", "🌼", "🌷", "🌹", "🏵️", "💐", "🌿", "🍀", "🪷", "🥀", "🪴", "🌱", "🌾", "🌵", "🎋", "🎍", "🍃", "🍂", "🍁", "🌴", "🌲", "🌳", "🎄", "🌰"],
        numberOfPairs: 8,
        color: .green,
        cardBackColor: .green,
        pieStartAngle: .degrees(-90),
        pieEndAngle: .degrees(110)
    )
    
    static let animals = Theme(
        name: "Животные",
        emojis: ["🐶", "🐱", "🐭", "🐹", "🐰", "🦊", "🐻", "🐼", "🐨", "🐯", "🦁", "🐮", "🐷", "🐸", "🐵", "🐔", "🐧", "🐦", "🐤", "🦆", "🦅", "🦉", "🦇", "🐺", "🐗", "🐴"],
        numberOfPairs: 8,
        color: .orange,
        cardBackColor: .orange,
        pieStartAngle: .degrees(0),
        pieEndAngle: .degrees(120)
    )
    
    static let food = Theme(
        name: "Еда",
        emojis: ["🍎", "🍊", "🍋", "🍌", "🍉", "🍇", "🍓", "🫐", "🍒", "🍑", "🥝", "🍍", "🥭", "🥥", "🍅", "🥑", "🍆", "🥔", "🥕", "🌽", "🌶️", "🫑", "🥒", "🥬", "🥦", "🧄"],
        numberOfPairs: 8,
        color: .red,
        cardBackColor: .red,
        pieStartAngle: .degrees(45),
        pieEndAngle: .degrees(180)
    )
    
    static let all: [Theme] = [flowers, animals, food]
    
    static func random(with difficulty: Difficulty) -> Theme {
        var randomTheme = all.randomElement()!
        randomTheme.numberOfPairs = difficulty.numberOfPairs
        return randomTheme
    }
    
    mutating func setDifficulty(_ difficulty: Difficulty) {
        self.numberOfPairs = difficulty.numberOfPairs
    }
}

enum Difficulty: String, CaseIterable, Identifiable {
    case easy = "Легко"
    case medium = "Средне"
    case hard = "Сложно"
    
    var id: String { rawValue }
    
    var numberOfPairs: Int {
        switch self {
        case .easy: return 8
        case .medium: return 12
        case .hard: return 24
        }
    }
}
