import Foundation
import SwiftUI

// A simple Codable wrapper for Color
struct CodableColor: Codable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    
    var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue)
    }
}

enum PetType: String, Codable, CaseIterable {
    case dog = "dog"
    case cat = "cat"
    case bird = "bird"
    case rabbit = "rabbit"
    
    var iconName: String {
        switch self {
        case .dog: return "dog.fill"
        case .cat: return "cat.fill"
        case .bird: return "bird.fill"
        case .rabbit: return "hare.fill" // SF Symbols has a hare for rabbit
        }
    }
}

struct Pet: Codable {
    var name: String
    var petType: PetType
    var color: CodableColor
    
    // Health System
    var health: Double = 1.0 // 1.0 is full health, 0.0 is game over
    var lastUpdateTimestamp: Date = Date()
    
    // Progress
    var level: Int = 1
    var happinessPoints: Int = 0
    
    // Inventory & Currency
    var foodCount: Int = 5
    var waterCount: Int = 5
    var adaCoins: Int = 100 // Start with 100 coins
    
    // Mini-game life system
    var gameHearts: Int = 3
    var lastHeartRefillTimestamp: Date = Date()
    
    // Needs are represented as values between 0.0 (empty) and 1.0 (full)
    var hunger: Double = 1.0
    var thirst: Double = 1.0
    var hygiene: Double = 1.0
    var love: Double = 1.0
    var energy: Double = 1.0 // Represents both play and sleep needs
    
    // CodingKeys, init, etc.
    enum CodingKeys: String, CodingKey {
        case id, name, petType, color, level, happinessPoints
        case health, hunger, thirst, hygiene, love, energy
        case lastUpdateTimestamp
        case foodCount, waterCount, adaCoins
        case gameHearts, lastHeartRefillTimestamp
    }
    
    init(id: UUID = UUID(), name: String, petType: PetType, color: CodableColor) {
        self.name = name
        self.petType = petType
        self.color = color
        self.foodCount = 5
        self.waterCount = 5
        self.adaCoins = 100
        self.gameHearts = 3
        self.lastHeartRefillTimestamp = Date()
    }
} 