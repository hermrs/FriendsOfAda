import Foundation
import Combine

class MemoryGameViewModel: ObservableObject {
    
    @Published var cards: [MemoryCard] = []
    @Published var moves: Int = 0
    
    private var indexOfFirstFlippedCard: Int?
    var onGameEnd: ((_ wasCorrect: Bool) -> Void)?
    
    // Using SF Symbols for card content for now
    private let cardContents = ["tortoise.fill", "hare.fill", "ant.fill", "ladybug.fill"]
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // For a 2x2 grid, we need 2 pairs (4 cards total)
        let neededPairs = 2
        let contentForGame = Array(cardContents.prefix(neededPairs))
        
        var gameCards: [MemoryCard] = []
        for content in contentForGame {
            gameCards.append(MemoryCard(content: content))
            gameCards.append(MemoryCard(content: content)) // Add the pair
        }
        
        cards = gameCards.shuffled()
        moves = 0
    }
    
    func choose(card: MemoryCard) {
        // Find the index of the chosen card
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }) else { return }
        
        // Ignore if the card is already flipped or matched
        if cards[chosenIndex].isFlipped || cards[chosenIndex].isMatched {
            return
        }
        
        moves += 1
        
        if let potentialMatchIndex = indexOfFirstFlippedCard {
            // A second card is flipped, check for a match
            cards[chosenIndex].isFlipped = true
            
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                // It's a match!
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            }
            
            indexOfFirstFlippedCard = nil // Reset for the next turn
            
        } else {
            // This is the first card being flipped in a turn
            // Flip all other cards down
            for index in cards.indices {
                if !cards[index].isMatched {
                    cards[index].isFlipped = false
                }
            }
            indexOfFirstFlippedCard = chosenIndex
            cards[chosenIndex].isFlipped = true
        }
        
        // Check if game is over
        if cards.allSatisfy({ $0.isMatched }) {
            // Use a slight delay to let the user see the last match
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.onGameEnd?(true)
            }
        }
    }
}

// Data model for a single card
struct MemoryCard: Identifiable {
    let id = UUID()
    let content: String // e.g., the name of the SF Symbol
    var isFlipped = false
    var isMatched = false
} 