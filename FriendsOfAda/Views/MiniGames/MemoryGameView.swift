import SwiftUI

struct MemoryGameView: View {
    @StateObject private var viewModel = MemoryGameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var onGameComplete: (Bool) -> Void
    
    // Define a 2-column grid
    private let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]
    
    var body: some View {
        VStack {
            Text("Hafıza Kartları")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text("Hamle: \(viewModel.moves)")
                .font(.title2)
            
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.cards) { card in
                    CardView(card: card)
                        .onTapGesture {
                            viewModel.choose(card: card)
                        }
                }
            }
            .padding()
            
            Button("Yeni Oyun") {
                viewModel.startNewGame()
            }
            .padding()
            
            Spacer()
        }
        .padding()
        .onAppear {
            viewModel.onGameEnd = { wasCorrect in
                onGameComplete(wasCorrect)
                dismiss()
            }
        }
    }
}

// Represents a single card view
struct CardView: View {
    let card: MemoryCard
    
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
        .aspectRatio(1, contentMode: .fit) // Make the card a square
    }
}


struct MemoryGameView_Previews: PreviewProvider {
    static var previews: some View {
        MemoryGameView(onGameComplete: { _ in })
    }
}
