import SwiftUI

struct MainGameView: View {
    @EnvironmentObject var viewModel: PetViewModel
    @State private var showingMathGame = false // State to control the sheet
    @State private var showingMemoryGame = false // State for memory game
    @State private var showingPetShop = false // State for Pet Shop
    @State private var showingWalkView = false // State for Walk View
    
    var body: some View {
        // Only show the main content if a pet exists.
        if let pet = viewModel.pet {
            ZStack {
                ScrollView {
                    VStack(spacing: 20) {
                        Text("Ada's Friend: \(pet.name)")
                            .font(.largeTitle)
                        
                        Text("Level: \(pet.level)")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                        
                        // Placeholder for pet animation/image
                        Image(systemName: pet.petType.iconName)
                            .font(.system(size: 100))
                            .foregroundColor(pet.color.swiftUIColor)
                        
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
                                    viewModel.lovePet()
                                }) {
                                    Text("Love")
                                        .padding()
                                        .background(Color.pink)
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                }
                                
                                Button(action: {
                                    viewModel.takeShower()
                                }) {
                                    Text("Take Shower")
                                        .padding()
                                        .background(Color.teal)
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
                                LocationButton(name: "Pet Shop", icon: "cart.fill", requiredLevel: 2, currentLevel: pet.level) {
                                    showingPetShop = true
                                }
                                LocationButton(name: "Park", icon: "pawprint.circle.fill", requiredLevel: 3, currentLevel: pet.level) {
                                    showingWalkView = true
                                }
                                LocationButton(name: "Veterinarian", icon: "cross.case.fill", requiredLevel: 4, currentLevel: pet.level) {}
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
                                
                                Button("Reset") {
                                    viewModel.resetGame()
                                }
                                .font(.caption)
                                .padding(8)
                                .background(Color.red.opacity(0.8))
                                .foregroundColor(.white)
                                .cornerRadius(8)
                            }
                        }
                        .padding(.top, 10)
                        
                        Spacer()
                    }
                    .padding()
                }
                
                // Game Over Overlay
                if pet.health <= 0 {
                    Color.black.opacity(0.7).ignoresSafeArea()
                    VStack(spacing: 20) {
                        Text("Oyun Bitti")
                            .font(.largeTitle)
                            .foregroundColor(.white)
                        Text("Evcil hayvanın sağlığı tükendi!")
                            .foregroundColor(.white)
                        
                        Button(action: {
                            viewModel.revive()
                        }) {
                            Text("Dirilt (100 AdaCoin)")
                                .padding()
                                .background(pet.adaCoins >= 100 ? Color.green : Color.gray)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                        .disabled(pet.adaCoins < 100)
                        
                        Button(action: {
                            viewModel.resetGame()
                        }) {
                            Text("Yeniden Başla")
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
                    // Also give some energy and love for playing
                    if viewModel.pet != nil {
                        viewModel.pet!.energy = min(1.0, viewModel.pet!.energy + 0.2)
                        viewModel.pet!.love = min(1.0, viewModel.pet!.love + 0.1)
                    }
                }
            }
            .sheet(isPresented: $showingMemoryGame) {
                MemoryGameView { wasCorrect in
                    if wasCorrect {
                        // Give a fixed amount of points for memory game for now
                        viewModel.addHappinessPoints(20)
                        if viewModel.pet != nil {
                            viewModel.pet!.energy = min(1.0, viewModel.pet!.energy + 0.2)
                            viewModel.pet!.love = min(1.0, viewModel.pet!.love + 0.1)
                        }
                    }
                }
            }
            .sheet(isPresented: $showingPetShop) {
                PetShopView(viewModel: viewModel)
            }
            .sheet(isPresented: $showingWalkView) {
                WalkView { distance in
                    viewModel.walkPet(distanceInMeters: distance)
                }
            }
        } else {
            // Show a loading view if the pet data is not yet available
            VStack {
                Text("Yükleniyor...")
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

// We can't preview this view directly anymore as it depends on an EnvironmentObject.
// We'll preview the main ContentView instead.
/*
struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}
*/ 