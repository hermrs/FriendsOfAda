import Foundation
import Combine

class PetViewModel: ObservableObject {
    @Published var pet: Pet
    
    private var timer: Timer?
    private var cancellables = Set<AnyCancellable>() // To hold subscriptions
    
    private let userDefaultsKey = "savedPet"

    init() {
        if let savedPet = Self.loadPet() {
            self.pet = savedPet
        } else {
            self.pet = Pet(name: "Buddy")
        }
        
        startNeedsDecay()
        
        // Save the pet's state whenever it changes
        $pet.sink { [weak self] updatedPet in
            self?.savePet(updatedPet)
        }.store(in: &cancellables)
    }
    
    deinit {
        timer?.invalidate()
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
        pet.hunger = max(0, pet.hunger - 0.02)
        pet.thirst = max(0, pet.thirst - 0.03)
        pet.hygiene = max(0, pet.hygiene - 0.01)
        pet.love = max(0, pet.love - 0.015)
        pet.energy = max(0, pet.energy - 0.025)
    }
    
    private func savePet(_ pet: Pet) {
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
        return pet.level * 100
    }
    
    func addHappinessPoints(_ points: Int) {
        pet.happinessPoints += points
        pet.adaCoins += points // Also award AdaCoins
        checkForLevelUp()
    }
    
    private func checkForLevelUp() {
        if pet.happinessPoints >= pointsForNextLevel {
            pet.level += 1
            pet.happinessPoints = 0 // Reset points for the new level
            // Here we can also trigger some celebration animation in the future
        }
    }
    
    // MARK: - Interaction Methods
    
    func feed() {
        if pet.foodCount > 0 {
            pet.foodCount -= 1
            pet.hunger = min(1.0, pet.hunger + 0.3)
            addHappinessPoints(10)
        } else {
            // Optionally, we can give feedback to the user that they are out of food.
        }
    }
    
    func giveWater() {
        if pet.waterCount > 0 {
            pet.waterCount -= 1
            pet.thirst = min(1.0, pet.thirst + 0.3)
            addHappinessPoints(10)
        } else {
            // Optionally, we can give feedback to the user that they are out of water.
        }
    }
    
    // MARK: - Shop Methods
    
    func buyFood() {
        let foodCost = 15
        if pet.adaCoins >= foodCost {
            pet.adaCoins -= foodCost
            pet.foodCount += 1
        }
    }
    
    func buyWater() {
        let waterCost = 10
        if pet.adaCoins >= waterCost {
            pet.adaCoins -= waterCost
            pet.waterCount += 1
        }
    }
    
    // MARK: - Test/Debug Methods
    func forceLevelUp() {
        pet.level += 1
        pet.happinessPoints = 0
        // We could also call the level up check to be safe
        // but for a direct level up, this is fine.
    }
    
    // Other interaction methods will be added here
} 