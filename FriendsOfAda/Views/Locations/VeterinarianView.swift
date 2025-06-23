import SwiftUI

struct VeterinarianView: View {
    @ObservedObject var viewModel: PetViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Veterinarian")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if let pet = viewModel.pet {
                Text("Current Health: \(Int(pet.health * 100))%")
                    .font(.title2)
                
                Text("AdaCoins: \(pet.adaCoins)")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
                
                VStack(spacing: 15) {
                    HealingButton(
                        label: "Small Heal (10% HP)",
                        cost: 1000,
                        currentCoins: pet.adaCoins
                    ) {
                        viewModel.healPet(percentage: 0.1, cost: 1000)
                    }
                    
                    HealingButton(
                        label: "Medium Heal (50% HP)",
                        cost: 5000,
                        currentCoins: pet.adaCoins
                    ) {
                        viewModel.healPet(percentage: 0.5, cost: 5000)
                    }
                    
                    HealingButton(
                        label: "Full Heal (100% HP)",
                        cost: 10000,
                        currentCoins: pet.adaCoins
                    ) {
                        viewModel.healPet(percentage: 1.0, cost: 10000)
                    }
                }
                
                Spacer()
                
                Button("Close") {
                    dismiss()
                }
            } else {
                Text("Could not load pet information.")
            }
        }
        .padding()
    }
}

struct HealingButton: View {
    let label: String
    let cost: Int
    let currentCoins: Int
    let action: () -> Void
    
    private var canAfford: Bool {
        currentCoins >= cost
    }
    
    var body: some View {
        Button(action: action) {
            HStack {
                Text(label)
                Spacer()
                Text("\(cost) Coin")
                    .fontWeight(.semibold)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(canAfford ? Color.green : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(12)
        }
        .disabled(!canAfford)
    }
}

struct VeterinarianView_Previews: PreviewProvider {
    static var previews: some View {
        VeterinarianView(viewModel: PetViewModel())
    }
} 