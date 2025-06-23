import Foundation
import Combine
import SwiftUI // For Binding

class PetViewModel: ObservableObject {
    @Published var pet: Pet?
    
    private var timer: Timer?
    private var energyRegenerationTimer: Timer?
    private var cancellables = Set<AnyCancellable>() // To hold subscriptions
    
    private let userDefaultsKey = "savedPet"

    init() {
        self.pet = Self.loadPet()
        
        startNeedsDecay()
        
        // If the app was closed while energy was regenerating, restart it
        if let pet = pet, pet.energy <= 0 {
            startEnergyRegeneration()
        }
        
        // Save the pet's state whenever it changes
        $pet
            .debounce(for: .seconds(1), scheduler: RunLoop.main) // Add a debounce to avoid excessive saving
            .sink { [weak self] updatedPet in
            self?.savePet(updatedPet)
        }.store(in: &cancellables)
    }
    
    deinit {
        timer?.invalidate()
        energyRegenerationTimer?.invalidate()
    }
    
    func startNeedsDecay() {
        // Invalidate existing timer before starting a new one
        timer?.invalidate()
        
        // This timer will fire every 5 seconds to decrease the pet's needs
        timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { [weak self] _ in
            self?.decayNeeds()
        }
    }
    
    private func decayNeeds() {
        guard pet != nil else { return }
        
        let now = Date()
        let timePassed = now.timeIntervalSince(pet!.lastUpdateTimestamp)
        pet!.lastUpdateTimestamp = now
        
        // Decay rate per second
        let decayRate = 0.001 // This is a very slow decay, can be adjusted
        let decayAmount = decayRate * timePassed
        
        // Decay primary needs
        pet!.hunger = max(0, pet!.hunger - decayAmount)
        pet!.thirst = max(0, pet!.thirst - decayAmount * 1.5) // Thirst decays faster
        pet!.love = max(0, pet!.love - decayAmount * 0.8) // Love decays a bit slower
        pet!.energy = max(0, pet!.energy - decayAmount * 0.5)
        pet!.hygiene = max(0, pet!.hygiene - decayAmount * 0.3)
        
        // If critical needs are zero, health starts to decrease
        var healthDecayAmount: Double = 0
        if pet!.hunger == 0 {
            healthDecayAmount += decayAmount
        }
        if pet!.thirst == 0 {
            healthDecayAmount += decayAmount
        }
        if pet!.love == 0 {
            healthDecayAmount += decayAmount
        }
        
        if healthDecayAmount > 0 {
            pet!.health = max(0, pet!.health - healthDecayAmount)
        }
        
        if pet!.energy <= 0 {
            startEnergyRegeneration()
        }
    }
    
    private func savePet(_ pet: Pet?) {
        guard let pet = pet else {
            UserDefaults.standard.removeObject(forKey: userDefaultsKey)
            return
        }
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(pet) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    private static func loadPet() -> Pet? {
        let defaults = UserDefaults.standard
        if let savedPetData = defaults.object(forKey: "savedPet") as? Data {
            let decoder = JSONDecoder()
            if let loadedPet = try? decoder.decode(Pet.self, from: savedPetData) {
                return loadedPet
            }
        }
        return nil
    }
    
    // MARK: - Progression
    
    var pointsForNextLevel: Int {
        guard let pet = pet else { return 0 }
        return pet.level * 100
    }
    
    func addHappinessPoints(_ points: Int) {
        guard pet != nil else { return }
        pet?.happinessPoints += points
        // Game rewards are now handled separately
        checkForLevelUp()
    }
    
    func addAdaCoins(_ amount: Int) {
        guard pet != nil else { return }
        pet?.adaCoins += amount
    }
    
    private func checkForLevelUp() {
        guard pet != nil else { return }
        if pet!.happinessPoints >= pointsForNextLevel {
            pet!.level += 1
            pet!.happinessPoints = 0 // Reset points for the new level
            // Here we can also trigger some celebration animation in the future
        }
    }
    
    // MARK: - Achievement System

    func awardAchievement(_ achievement: Achievement) {
        guard pet != nil, !pet!.earnedAchievements.contains(achievement) else { return }
        pet!.earnedAchievements.insert(achievement)
        HapticManager.shared.playSuccess()
        
        // Report the achievement to Game Center
        GameCenterManager.shared.reportAchievement(identifier: achievement.rawValue, percentComplete: 100.0)
    }

    private func checkAchievements() {
        guard pet != nil else { return }

        // Pet Lover
        if pet!.loveInteractionCount >= 25 {
            awardAchievement(.petLover)
        }

        // Big Spender
        if pet!.totalCoinsSpent >= 500 {
            awardAchievement(.shoppingSpree)
        }
    }
    
    // MARK: - Interaction Methods
    
    func feed() {
        guard pet != nil, pet!.foodCount > 0 else { return }
        pet!.foodCount -= 1
        pet!.hunger = min(1.0, pet!.hunger + 0.3)
        addHappinessPoints(10)
        awardAchievement(.firstFeed)
    }
    
    func giveWater() {
        guard pet != nil, pet!.waterCount > 0 else { return }
        pet!.waterCount -= 1
        pet!.thirst = min(1.0, pet!.thirst + 0.3)
        addHappinessPoints(10)
    }
    
    func lovePet() {
        guard let pet = pet, energyRegenerationTimer == nil else { return }
        
        self.pet!.love = min(1.0, pet.love + 0.25)
        self.pet!.energy = max(0, pet.energy - 0.05) // Loving interaction consumes a little energy
        self.pet!.loveInteractionCount += 1
        
        HapticManager.shared.playPetting()
        addHappinessPoints(15)

        if self.pet!.loveInteractionCount >= 25 {
            awardAchievement(.petLover)
        }
        
        if self.pet!.energy <= 0 {
            startEnergyRegeneration()
        }
    }
    
    func takeShower() {
        guard let pet = pet, energyRegenerationTimer == nil else { return }
        
        self.pet!.hygiene = min(1.0, pet.hygiene + 0.4)
        self.pet!.energy = max(0, pet.energy - 0.1) // Showering also consumes energy
        addHappinessPoints(5)
        
        if self.pet!.energy <= 0 {
            startEnergyRegeneration()
        }
    }
    
    func calculateWalkReward(distanceInMeters: Double) -> (coins: Int, happiness: Int) {
        let happiness = Int(distanceInMeters / 100.0) * 5
        let coins = Int(distanceInMeters / 100.0) * 10 // Give more coins
        return (coins, happiness)
    }
    
    func walkPet(distanceInMeters: Double) {
        guard pet != nil else { return }
        
        // Stop energy regeneration if we are walking, as it restores energy
        stopEnergyRegeneration()
        
        let reward = calculateWalkReward(distanceInMeters: distanceInMeters)
        
        addHappinessPoints(reward.happiness)
        addAdaCoins(reward.coins)
        
        if distanceInMeters >= 1000 {
            awardAchievement(.longWalk)
        }
        
        pet!.energy = min(1.0, pet!.energy + (distanceInMeters / 1000.0) * 0.1) // More distance, more energy
    }
    
    // MARK: - Shop Methods
    
    func buyFood() {
        guard pet != nil else { return }
        let foodCost = 15
        if pet!.adaCoins >= foodCost {
            pet!.adaCoins -= foodCost
            pet!.foodCount += 1
            pet!.totalCoinsSpent += foodCost
            checkAchievements()
        }
    }
    
    func buyWater() {
        guard pet != nil else { return }
        let waterCost = 10
        if pet!.adaCoins >= waterCost {
            pet!.adaCoins -= waterCost
            pet!.waterCount += 1
            pet!.totalCoinsSpent += waterCost
            checkAchievements()
        }
    }
    
    // MARK: - Test/Debug Methods
    func forceLevelUp() {
        guard pet != nil else { return }
        pet!.level += 1
        pet!.happinessPoints = 0
        // We could also call the level up check to be safe
        // but for a direct level up, this is fine.
    }
    
    func addDebugCoins() {
        guard pet != nil else { return }
        pet?.adaCoins += 1000
    }
    
    // MARK: - Game Over and Revival
    
    func revive() {
        guard pet != nil, pet!.health <= 0, pet!.adaCoins >= 100 else { return }
        
        pet!.health = 0.5 // Revive with half health
        pet!.adaCoins -= 100
        savePet(self.pet)
    }
    
    // MARK: - Game Play Hearts
    
    func refillHearts() {
        guard pet != nil else { return }
        
        let hoursPassed = Calendar.current.dateComponents([.hour], from: pet!.lastHeartRefillTimestamp, to: Date()).hour ?? 0
        let heartsToRefill = hoursPassed / 24
        
        if heartsToRefill > 0 {
            pet!.gameHearts = min(3, pet!.gameHearts + heartsToRefill)
            pet!.lastHeartRefillTimestamp = Date()
        }
    }
    
    func useGameHeart() {
        guard pet != nil, pet!.gameHearts > 0 else { return }
        pet!.gameHearts -= 1
        
        // Playing a game also costs energy
        guard energyRegenerationTimer == nil else { return }
        pet!.energy = max(0, pet!.energy - 0.15)
        if pet!.energy <= 0 {
            startEnergyRegeneration()
        }
    }
    
    // MARK: - Veterinarian
    
    func healPet(percentage: Double, cost: Int) {
        guard let pet = pet, pet.adaCoins >= cost else { return }
        
        self.pet!.adaCoins -= cost
        self.pet!.health = min(1.0, pet.health + percentage)
        self.pet!.totalCoinsSpent += cost
        checkAchievements()
        HapticManager.shared.playSuccess()
    }
    
    func resetGame() {
        // This function will now completely reset the game state.
        
        // Remove the pet data from UserDefaults
        UserDefaults.standard.removeObject(forKey: "savedPet")
        
        // Set the current pet to nil, which will trigger the UI to go back to the creation screen.
        self.pet = nil
    }
    
    // MARK: - Energy Regeneration
    
    private func startEnergyRegeneration() {
        // Don't start a new timer if one is already running or if energy is not zero
        guard energyRegenerationTimer == nil, let pet = pet, pet.energy <= 0 else { return }
        
        let maxEnergy = 1.0
        let regenerationDuration = 300.0 // 5 minutes in seconds
        let energyPerSecond = maxEnergy / regenerationDuration
        
        energyRegenerationTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            guard let self = self, var pet = self.pet else {
                timer.invalidate()
                return
            }
            
            // If energy was restored by other means, stop the timer
            if pet.energy > 0 {
                self.stopEnergyRegeneration()
                return
            }

            pet.energy += energyPerSecond
            
            if pet.energy >= maxEnergy {
                pet.energy = maxEnergy
                self.pet = pet
                self.stopEnergyRegeneration()
            } else {
                self.pet = pet
            }
        }
    }
    
    private func stopEnergyRegeneration() {
        energyRegenerationTimer?.invalidate()
        energyRegenerationTimer = nil
    }
    
    // Other interaction methods will be added here
} 