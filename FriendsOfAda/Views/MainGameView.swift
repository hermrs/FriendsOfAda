import SwiftUI

struct MainGameView: View {
    @StateObject private var viewModel = PetViewModel()
    @State private var showingMathGame = false // State to control the sheet
    @State private var showingMemoryGame = false // State for memory game
    @State private var showingPetShop = false // State for Pet Shop
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Ada's Friend: \(viewModel.pet.name)")
                    .font(.largeTitle)
                
                Text("Level: \(viewModel.pet.level)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                
                // Placeholder for pet animation/image
                Image(systemName: "pawprint.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.brown)
                
                // Needs Indicators
                VStack(alignment: .leading, spacing: 10) {
                    NeedView(name: "Hunger", value: viewModel.pet.hunger, icon: "fork.knife")
                    NeedView(name: "Thirst", value: viewModel.pet.thirst, icon: "drop.fill")
                    NeedView(name: "Hygiene", value: viewModel.pet.hygiene, icon: "sparkles")
                    NeedView(name: "Love", value: viewModel.pet.love, icon: "heart.fill")
                    NeedView(name: "Energy", value: viewModel.pet.energy, icon: "bolt.fill")
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(15)
                
                // Progress to next level
                VStack {
                    Text("Next Level Progress")
                    ProgressView(value: Double(viewModel.pet.happinessPoints), total: Double(viewModel.pointsForNextLevel))
                        .accentColor(.yellow)
                    Text("\(viewModel.pet.happinessPoints) / \(viewModel.pointsForNextLevel) HP")
                        .font(.caption)
                }
                .padding()
                .background(Color(UIColor.systemGray6))
                .cornerRadius(15)
                
                // Interaction Buttons
                VStack {
                    HStack(spacing: 20) {
                        Button(action: {
                            viewModel.feed()
                        }) {
                            Text("Feed (\(viewModel.pet.foodCount))")
                                .padding()
                                .background(Color.green)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            viewModel.giveWater()
                        }) {
                            Text("Give Water (\(viewModel.pet.waterCount))")
                                .padding()
                                .background(Color.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                    
                    // Button to launch the math mini-game
                    Button(action: {
                        showingMathGame = true
                    }) {
                        Text("Play Math Game")
                            .padding()
                            .background(Color.purple)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    
                    // Button to launch the memory mini-game
                    Button(action: {
                        showingMemoryGame = true
                    }) {
                        Text("Play Memory Game")
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                
                // Unlocked Locations
                VStack {
                    Text("Locations")
                        .font(.headline)
                    HStack(spacing: 10) {
                        LocationButton(name: "Pet Shop", icon: "cart.fill", requiredLevel: 2, currentLevel: viewModel.pet.level) {
                            showingPetShop = true
                        }
                        LocationButton(name: "Park", icon: "pawprint.circle.fill", requiredLevel: 3, currentLevel: viewModel.pet.level) {}
                        LocationButton(name: "Veterinarian", icon: "cross.case.fill", requiredLevel: 4, currentLevel: viewModel.pet.level) {}
                    }
                }
                .padding(.top)

                // MARK: - Test Buttons
                VStack {
                    Text("Test Kontrolleri")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    HStack {
                        Button("+50 HP") {
                            viewModel.addHappinessPoints(50)
                        }
                        .font(.caption)
                        .padding(8)
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        
                        Button("Seviye Atla") {
                            viewModel.forceLevelUp()
                        }
                        .font(.caption)
                        .padding(8)
                        .background(Color.gray.opacity(0.7))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                    }
                }
                .padding(.top, 10)
                
                Spacer()
            }
            .padding()
        }
        .sheet(isPresented: $showingMathGame) {
            MathMinigameView { score in
                viewModel.addHappinessPoints(score)
                // Also give some energy and love for playing
                viewModel.pet.energy = min(1.0, viewModel.pet.energy + 0.2)
                viewModel.pet.love = min(1.0, viewModel.pet.love + 0.1)
            }
        }
        .sheet(isPresented: $showingMemoryGame) {
            MemoryGameView { wasCorrect in
                if wasCorrect {
                    // Give a fixed amount of points for memory game for now
                    viewModel.addHappinessPoints(20)
                    viewModel.pet.energy = min(1.0, viewModel.pet.energy + 0.2)
                    viewModel.pet.love = min(1.0, viewModel.pet.love + 0.1)
                }
            }
        }
        .sheet(isPresented: $showingPetShop) {
            PetShopView(viewModel: viewModel)
        }
    }
}

// A new helper view for location buttons
struct LocationButton: View {
    let name: String
    let icon: String
    let requiredLevel: Int
    let currentLevel: Int
    let action: () -> Void
    
    private var isLocked: Bool {
        currentLevel < requiredLevel
    }
    
    var body: some View {
        Button(action: action) {
            VStack {
                if isLocked {
                    Image(systemName: "lock.fill")
                    Text("Lvl \(requiredLevel)")
                        .font(.caption)
                } else {
                    Image(systemName: icon)
                    Text(name)
                        .font(.caption)
                }
            }
            .font(.title2)
            .frame(width: 80, height: 60)
            .padding(5)
            .background(isLocked ? Color.gray.opacity(0.5) : Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .disabled(isLocked)
    }
}

// A helper view for displaying a single need
struct NeedView: View {
    let name: String
    let value: Double
    let icon: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 25)
            Text(name)
                .frame(width: 80, alignment: .leading)
            ProgressView(value: value, total: 1.0)
                .accentColor(colorForValue(value))
        }
    }
    
    private func colorForValue(_ value: Double) -> Color {
        if value > 0.6 {
            return .green
        } else if value > 0.3 {
            return .yellow
        } else {
            return .red
        }
    }
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
} 