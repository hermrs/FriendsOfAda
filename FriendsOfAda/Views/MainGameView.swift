import SwiftUI
import RealityKit

struct MainGameView: View {
    @EnvironmentObject var viewModel: PetViewModel
    @State private var showingMathGame = false // State to control the sheet
    @State private var showingMemoryGame = false // State for memory game
    @State private var showingPetShop = false // State for Pet Shop
    @State private var showingWalkView = false // State for Walk View
    @State private var showingVeterinarian = false
    @State private var showingAchievements = false
    @State private var showingMazeGame = false
    @State private var showingWashingGame = false
    @State private var showingLovingGame = false
    @State private var showLoveEffect = false
    
    var body: some View {
        // Only show the main content if a pet exists.
        if let pet = viewModel.pet {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        HStack {
                            Text("Ada's Friend: \(pet.name)")
                                .font(.largeTitle)
                            Spacer()
                            // Currency and Hearts display
                            VStack(alignment: .trailing) {
                                HStack {
                                    Image(systemName: "bitcoinsign.circle.fill")
                                    Text("\(pet.adaCoins)")
                                }
                                .font(.title2)
                                HStack {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.red)
                                    Text("\(pet.gameHearts)/3")
                                }
                                .font(.headline)
                            }
                        }
                        
                        Text("Level: \(pet.level)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        // Placeholder for pet animation/image
                        ModelView(petType: pet.petType)
                            .frame(height: 250)
                            .padding(.vertical, 20)
                        
                        // Needs Indicators
                        VStack(alignment: .leading, spacing: 10) {
                            NeedView(name: "Health", value: pet.health, icon: "heart.fill", color: .red)
                            Divider()
                            NeedView(name: "Hunger", value: pet.hunger, icon: "fork.knife")
                            NeedView(name: "Thirst", value: pet.thirst, icon: "drop.fill")
                            NeedView(name: "Hygiene", value: pet.hygiene, icon: "sparkles")
                            NeedView(name: "Love", value: pet.love, icon: "heart.fill")
                            NeedView(name: "Energy", value: pet.energy, icon: "bolt.fill")
                        }
                        .padding()
                        .background(Color(UIColor.systemGray6))
                        .cornerRadius(15)
                        
                        // Progress to next level
                        VStack {
                            Text("Next Level Progress")
                            ProgressView(value: Double(pet.happinessPoints), total: Double(viewModel.pointsForNextLevel))
                                .accentColor(.yellow)
                            Text("\(pet.happinessPoints) / \(viewModel.pointsForNextLevel) HP")
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
                                    Text("Feed (\(pet.foodCount))")
                                        .padding()
                                        .background(Color.green)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    viewModel.giveWater()
                                }) {
                                    Text("Give Water (\(pet.waterCount))")
                                        .padding()
                                        .background(Color.blue)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                            }
                            
                            HStack(spacing: 20) {
                                Button(action: {
                                    showingWashingGame = true
                                }) {
                                    Text("Wash")
                                        .padding()
                                        .frame(minWidth: 120)
                                        .background(Color.teal)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .disabled(pet.energy <= 0)
                                
                                Button(action: {
                                    showingLovingGame = true
                                }) {
                                    Text("Love")
                                        .padding()
                                        .frame(minWidth: 120)
                                        .background(Color.pink)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                .disabled(pet.energy <= 0)
                            }
                            
                            // Button to launch the math mini-game
                            Button(action: {
                                viewModel.useGameHeart()
                                showingMathGame = true
                            }) {
                                Text("Play Math Game")
                                    .padding()
                                    .background(pet.gameHearts > 0 && pet.energy > 0 ? Color.purple : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(pet.gameHearts <= 0 || pet.energy <= 0)
                            
                            // Button to launch the memory mini-game
                            Button(action: {
                                viewModel.useGameHeart()
                                showingMemoryGame = true
                            }) {
                                Text("Play Memory Game")
                                    .padding()
                                    .background(pet.gameHearts > 0 && pet.energy > 0 ? Color.orange : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(pet.gameHearts <= 0 || pet.energy <= 0)

                            // Button to launch the maze mini-game
                            Button(action: {
                                viewModel.useGameHeart()
                                showingMazeGame = true
                            }) {
                                Text("Play Maze Game")
                                    .padding()
                                    .background(pet.gameHearts > 0 && pet.energy > 0 ? Color.brown : Color.gray)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                            .disabled(pet.gameHearts <= 0 || pet.energy <= 0)
                        }
                        
                        // Unlocked Locations
                        VStack {
                            Text("Locations")
                                .font(.headline)
                            HStack(spacing: 10) {
                                LocationButton(name: "Pet Shop", icon: "cart.fill", requiredLevel: 2, currentLevel: pet.level) {
                                    showingPetShop = true
                                }
                                LocationButton(name: "Park", icon: "pawprint.circle.fill", requiredLevel: 3, currentLevel: pet.level) {
                                    showingWalkView = true
                                }
                                LocationButton(name: "Veterinarian", icon: "cross.case.fill", requiredLevel: 4, currentLevel: pet.level) {
                                    showingVeterinarian = true
                                }
                            }
                        }
                        .padding(.top)

                        // Achievements Button
                        Button(action: {
                            showingAchievements = true
                        }) {
                            HStack {
                                Image(systemName: "star.circle.fill")
                                Text("Achievements")
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(10)
                        }
                        .padding(.top, 5)

                        // MARK: - Test Buttons
                        VStack {
                            Text("Test Controls")
                                .font(.caption)
                                .foregroundColor(.secondary)
                            HStack {
                                Button("+50 HP") { viewModel.addHappinessPoints(50) }
                                Button("Level Up") { viewModel.forceLevelUp() }
                                Button("Fill Energy") { viewModel.fillEnergy() }
                            }
                            .buttonStyle(TestButtonStyle())
                            HStack {
                                Button("+1000 Coin") { viewModel.addDebugCoins() }
                                Button("Reset") { viewModel.resetGame() }
                            }
                            .buttonStyle(TestButtonStyle())

                            HStack {
                                ForEach(Achievement.allCases.prefix(3), id: \.self) { achievement in
                                    Button("Win: \(achievement.title)") {
                                        viewModel.awardAchievement(achievement)
                                    }
                                }
                            }
                            .buttonStyle(TestButtonStyle())
                            HStack {
                                ForEach(Achievement.allCases.suffix(from: 3), id: \.self) { achievement in
                                    Button("Win: \(achievement.title)") {
                                        viewModel.awardAchievement(achievement)
                                    }
                                }
                            }
                            .buttonStyle(TestButtonStyle())
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding()
                }
                
                // Love Effect Overlay
                if showLoveEffect {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.pink.opacity(0.8))
                        .transition(.scale.animation(.spring()))
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                withAnimation {
                                    showLoveEffect = false
                                }
                            }
                        }
                }
                
                // Game Over Overlay
                if pet.health <= 0 {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("Game Over")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Your pet has run out of health!")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            viewModel.revive()
                        }) {
                            Text("Revive (100 AdaCoin)")
                                .padding()
                                .background(pet.adaCoins >= 100 ? Color.green : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(pet.adaCoins < 100)
                        
                        Button(action: {
                            viewModel.resetGame()
                        }) {
                            Text("Restart")
                                .padding()
                                .background(Color.red)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingMathGame) {
                MathMinigameView { score in
                    viewModel.addHappinessPoints(score)
                    viewModel.addAdaCoins(score * 3)
                    if score >= 50 {
                        viewModel.awardAchievement(.mathGenius)
                    }
                    HapticManager.shared.playSuccess()
                }
            }
            .sheet(isPresented: $showingMemoryGame) {
                MemoryGameView {
                    viewModel.addHappinessPoints(15) // Award points for winning
                    viewModel.addAdaCoins(10)      // Award coins
                    HapticManager.shared.playSuccess()
                }
            }
            .sheet(isPresented: $showingMazeGame) {
                MazeMinigameView(viewModel: viewModel) { coins in
                    viewModel.addHappinessPoints(20) // Example points
                    viewModel.addAdaCoins(coins)
                    showingMazeGame = false
                }
            }
            .sheet(isPresented: $showingPetShop) {
                PetShopView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingWalkView) {
                WalkView()
                    .environmentObject(viewModel)
            }
            .sheet(isPresented: $showingVeterinarian) {
                VeterinarianView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingAchievements) {
                if let pet = viewModel.pet {
                    AchievementsView(earnedAchievements: pet.earnedAchievements)
                }
            }
            .sheet(isPresented: $showingWashingGame) {
                WashingMinigameView(viewModel: viewModel) {
                    viewModel.takeShower()
                    HapticManager.shared.playSuccess()
                }
            }
            .sheet(isPresented: $showingLovingGame) {
                LovingMinigameView(viewModel: viewModel) {
                    viewModel.lovePet()
                }
            }
            .onAppear {
                viewModel.refillHearts()
            }
        } else {
            // Show a loading view if the pet data is not yet available
            VStack {
                Text("Loading...")
                ProgressView()
            }
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
    var color: Color = .green
    
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
        if name == "Health" { return self.color }
        if value > 0.6 {
            return .green
        } else if value > 0.3 {
            return .yellow
        } else {
            return .red
        }
    }
}

// A style for test buttons to reduce repetition
struct TestButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.caption)
            .padding(8)
            .background(Color.gray.opacity(0.7))
            .foregroundColor(.white)
            .cornerRadius(8)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}

// We can't preview this view directly anymore as it depends on an EnvironmentObject.
// We'll preview the main ContentView instead.
/*
struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}
*/ 