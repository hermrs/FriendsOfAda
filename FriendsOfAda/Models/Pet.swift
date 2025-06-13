import Foundation

struct Pet: Codable {
    var name: String
    
    // Progress
    var level: Int = 1
    var happinessPoints: Int = 0
    
    // Inventory & Currency
    var adaCoins: Int = 0
    var foodCount: Int = 5
    var waterCount: Int = 5
    
    // Needs are represented as values between 0.0 (empty) and 1.0 (full)
    var hunger: Double = 1.0
    var thirst: Double = 1.0
    var hygiene: Double = 1.0
    var love: Double = 1.0
    var energy: Double = 1.0 // Represents both play and sleep needs
} 