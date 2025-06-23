import SwiftUI

struct MemoryGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // This callback is now only for winning a round
    var onGameWin: () -> Void
    
    // Dynamically create grid columns based on card count
    private var columns: [GridItem] {
        // For 6 cards, use a 2-column layout. For more, maybe 3.
        let columnCount = viewModel.cardCount > 4 ? 3 : 2
        return Array(repeating: .init(.flexible()), count: columnCount)
    }
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("Memory Cards")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button("Kapat") {
                    dismiss()
                }
                .padding(.horizontal)
                .padding(.vertical, 8)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
            }
            
            HStack {
                Text("Hamle: \(viewModel.moves)")
                Spacer()
                Text("Seri: \(viewModel.consecutiveWins)")
            }
            .font(.title2)
            
            // Re-calculable grid
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card, cardCount: viewModel.cardCount)
                        .onTapGesture {
                            viewModel.choose(card: card)
                        }
                }
            }
            
            if viewModel.cards.allSatisfy({ $0.isMatched }) && !viewModel.cards.isEmpty {
                Text("Tebrikler, kazandınız!")
                    .font(.title)
                    .foregroundColor(.green)
                    .transition(.scale)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Set up the callback for when a game is won
            viewModel.onGameWon = {
                onGameWin()
            }
        }
    }
}

// Represents a single card view
struct CardView: View {
    let card: MemoryCard
    let cardCount: Int // Pass card count for aspect ratio
    
    var body: some View {
        ZStack {
            let shape = RoundedRectangle(cornerRadius: 12)
            
            if card.isFlipped || card.isMatched {
                // Front of the card
                shape.fill().foregroundColor(.white)
                shape.strokeBorder(lineWidth: 3).foregroundColor(.blue)
                Image(systemName: card.content)
                    .font(.largeTitle)
                    .foregroundColor(.blue)
            } else {
                // Back of the card
                shape.fill().foregroundColor(.blue)
            }
        }
        .aspectRatio(cardCount > 4 ? 0.66 : 1, contentMode: .fit) // Make cards rectangular for larger grids
    }
}


struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(onGameWin: {})
    }
}
