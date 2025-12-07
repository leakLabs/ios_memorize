//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    
    var body: some View {
        EmojiMemoryGameView(viewModel: viewModel)
    }
}
