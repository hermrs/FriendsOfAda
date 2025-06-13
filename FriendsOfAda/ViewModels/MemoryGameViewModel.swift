import Foundation
import Combine

class MemoryGameViewModel: ObservableObject {
    
    @Published var cards: [MemoryCard] = []
    @Published var moves: Int = 0
    @Published var consecutiveWins: Int = 0
    @Published var cardCount: Int = 4 // Start with 4 cards (2x2)

    private var indexOfFirstFlippedCard: Int?
    var onGameWon: (() -> Void)?
    
    // Using SF Symbols for card content
    private let cardContents = ["tortoise.fill", "hare.fill", "ant.fill", "ladybug.fill", "fish.fill", "bird.fill"]
    
    init() {
        startNewGame()
    }
    
    func startNewGame() {
        // Reset game state
        moves = 0
        indexOfFirstFlippedCard = nil
        
        // Difficulty logic
        if consecutiveWins > 0 && consecutiveWins % 3 == 0 {
            // After every 3 wins, increase difficulty up to a max of 12 cards
            cardCount = min(12, cardCount + 2)
        }
        
        let neededPairs = cardCount / 2
        let contentForGame = Array(cardContents.prefix(neededPairs))
        
        var gameCards: [MemoryCard] = []
        for content in contentForGame {
            gameCards.append(MemoryCard(content: content))
            gameCards.append(MemoryCard(content: content)) // Add the pair
        }
        
        cards = gameCards.shuffled()
    }
    
    func choose(card: MemoryCard) {
        guard let chosenIndex = cards.firstIndex(where: { $0.id == card.id }),
              !cards[chosenIndex].isFlipped,
              !cards[chosenIndex].isMatched else {
            return
        }
        
        moves += 1
        
        if let potentialMatchIndex = indexOfFirstFlippedCard {
            // Second card flipped
            cards[chosenIndex].isFlipped = true
            
            if cards[chosenIndex].content == cards[potentialMatchIndex].content {
                // It's a match!
                cards[chosenIndex].isMatched = true
                cards[potentialMatchIndex].isMatched = true
            } else {
                // Not a match, flip them back after a delay
                let firstIndex = potentialMatchIndex
                let secondIndex = chosenIndex
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.cards[firstIndex].isFlipped = false
                    self.cards[secondIndex].isFlipped = false
                }
            }
            
            indexOfFirstFlippedCard = nil
        } else {
            // First card flipped
            indexOfFirstFlippedCard = chosenIndex
            cards[chosenIndex].isFlipped = true
        }
        
        // Check if game is over
        // Use a slight delay to let the user see the last match
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if self.cards.allSatisfy({ $0.isMatched }) {
                self.consecutiveWins += 1
                self.onGameWon?() // Notify the parent view of the win
                
                // Start a new game after a short delay
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    self.startNewGame()
                }
            }
        }
    }
}

// Data model for a single card
struct MemoryCard: Identifiable {
    let id = UUID()
    let content: String
    var isFlipped = false
    var isMatched = false
} 