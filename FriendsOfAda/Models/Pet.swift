import Foundation
import SwiftUI
import RealityKit // For SIMD3<Float>

// A simple Codable wrapper for Color
struct CodableColor: Codable, Hashable {
    var red: Double
    var green: Double
    var blue: Double
    
    var swiftUIColor: Color {
        Color(red: red, green: green, blue: blue)
    }
}

// Defines the type of pet the user can have
enum PetType: String, CaseIterable, Codable {
    case cat = "Cat"
    case dog = "Dog"
    case hamster = "Hamster"
    
    var iconName: String {
        switch self {
        case .cat: return "cat.fill"
        case .dog: return "dog.fill"
        case .hamster: return "hamster.fill"
        }
    }
    
    var modelName: String {
        switch self {
        case .cat:
            return "Cartoon_cat_pet_Free.usdz"
        case .dog:
            return "Free_Shar_Pei_Animated_Dog.usdz"
        case .hamster:
            return "HAMster.usdz"
        }
    }
    
    /// Provides model-specific adjustments for scale, position, and rotation.
    var configuration: (scale: SIMD3<Float>, position: SIMD3<Float>, rotation: simd_quatf) {
        switch self {
        case .cat:
            return (
                scale: [0.00005, 0.00005, 0.00005],
                position: [0.5, 0.2, 100],
                rotation: simd_quatf(angle: 0, axis: [0, 1, 0])
            )
        case .dog:
            return (
                scale: [0.0005, 0.0005, 0.0005],
                position: [0, -10, 100],
                rotation: simd_quatf(angle: 0, axis: [0, 1, 0])
            )
        case .hamster:
            return (
                scale: [0.0008, 0.0008, 0.0008],
                position: [0, 30, 500],
                rotation: simd_quatf(angle: .pi / 2, axis: [0, 1, 0])
            )
        }
    }
}

struct Pet: Codable, Identifiable {
    var id: UUID = UUID()
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
    
    // Achievement Tracking
    var earnedAchievements: Set<Achievement> = []
    var loveInteractionCount: Int = 0
    var totalCoinsSpent: Int = 0
    
    // Needs are represented as values between 0.0 (empty) and 1.0 (full)
    var hunger: Double = 1.0
    var thirst: Double = 1.0
    var hygiene: Double = 1.0
    var love: Double = 1.0
    var energy: Double = 1.0 // Represents both play and sleep needs
    
    // CodingKeys, init, etc.
    enum CodingKeys: String, CodingKey {
        case id, name, petType, color, level, happinessPoints, adaCoins
        case health, hunger, thirst, hygiene, love, energy
        case lastUpdateTimestamp
        case foodCount, waterCount
        case gameHearts, lastHeartRefillTimestamp
        case earnedAchievements, loveInteractionCount, totalCoinsSpent
    }
    
    // Custom init for creating a new pet
    init(id: UUID = UUID(), name: String, petType: PetType, color: CodableColor) {
        self.id = id
        self.name = name
        self.petType = petType
        self.color = color
        self.foodCount = 5
        self.waterCount = 5
        self.adaCoins = 100
        self.gameHearts = 3
        self.lastHeartRefillTimestamp = Date()
    }
    
    // Manual implementation of Decodable
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(UUID.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.petType = try container.decode(PetType.self, forKey: .petType)
        self.color = try container.decode(CodableColor.self, forKey: .color)
        self.level = try container.decode(Int.self, forKey: .level)
        self.happinessPoints = try container.decode(Int.self, forKey: .happinessPoints)
        self.health = try container.decode(Double.self, forKey: .health)
        self.hunger = try container.decode(Double.self, forKey: .hunger)
        self.thirst = try container.decode(Double.self, forKey: .thirst)
        self.hygiene = try container.decode(Double.self, forKey: .hygiene)
        self.love = try container.decode(Double.self, forKey: .love)
        self.energy = try container.decode(Double.self, forKey: .energy)
        self.lastUpdateTimestamp = try container.decode(Date.self, forKey: .lastUpdateTimestamp)
        self.foodCount = try container.decode(Int.self, forKey: .foodCount)
        self.waterCount = try container.decode(Int.self, forKey: .waterCount)
        self.adaCoins = try container.decode(Int.self, forKey: .adaCoins)
        self.gameHearts = try container.decode(Int.self, forKey: .gameHearts)
        self.lastHeartRefillTimestamp = try container.decode(Date.self, forKey: .lastHeartRefillTimestamp)
        self.earnedAchievements = try container.decode(Set<Achievement>.self, forKey: .earnedAchievements)
        self.loveInteractionCount = try container.decode(Int.self, forKey: .loveInteractionCount)
        self.totalCoinsSpent = try container.decode(Int.self, forKey: .totalCoinsSpent)
    }
    
    // Manual implementation of Encodable
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(petType, forKey: .petType)
        try container.encode(color, forKey: .color)
        try container.encode(level, forKey: .level)
        try container.encode(happinessPoints, forKey: .happinessPoints)
        try container.encode(health, forKey: .health)
        try container.encode(hunger, forKey: .hunger)
        try container.encode(thirst, forKey: .thirst)
        try container.encode(hygiene, forKey: .hygiene)
        try container.encode(love, forKey: .love)
        try container.encode(energy, forKey: .energy)
        try container.encode(lastUpdateTimestamp, forKey: .lastUpdateTimestamp)
        try container.encode(foodCount, forKey: .foodCount)
        try container.encode(waterCount, forKey: .waterCount)
        try container.encode(adaCoins, forKey: .adaCoins)
        try container.encode(gameHearts, forKey: .gameHearts)
        try container.encode(lastHeartRefillTimestamp, forKey: .lastHeartRefillTimestamp)
        try container.encode(earnedAchievements, forKey: .earnedAchievements)
        try container.encode(loveInteractionCount, forKey: .loveInteractionCount)
        try container.encode(totalCoinsSpent, forKey: .totalCoinsSpent)
    }
} 