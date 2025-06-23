import SwiftUI

struct PetShopView: View {
    @ObservedObject var viewModel: PetViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 20) {
            
            HStack {
                Text("Pet Shop")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                Spacer()
                Button("Close") {
                    dismiss()
                }
            }
            
            // We must safely unwrap the optional pet
            if let pet = viewModel.pet {
                HStack {
                    Image(systemName: "bitcoinsign.circle.fill")
                    Text("AdaCoins: \(pet.adaCoins)")
                }
                .font(.title2)
                .foregroundColor(.orange)

                Spacer()
                
                VStack(spacing: 20) {
                    Text("Products")
                        .font(.title)
                    
                    Button(action: {
                        viewModel.buyFood()
                    }) {
                        HStack {
                            Image(systemName: "fork.knife")
                            Text("Buy Food (15 Coins)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(pet.adaCoins >= 15 ? Color.green : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(pet.adaCoins < 15)
                    
                    Button(action: {
                        viewModel.buyWater()
                    }) {
                        HStack {
                            Image(systemName: "drop.fill")
                            Text("Buy Water (10 Coins)")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(pet.adaCoins >= 10 ? Color.blue : Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(pet.adaCoins < 10)
                }
                
                Spacer()
            } else {
                Spacer()
                Text("Loading pet information...")
                Spacer()
            }
        }
        .padding()
    }
}

struct PetShopView_Previews: PreviewProvider {
    static var previews: some View {
        // We pass a dummy ViewModel for the preview to work
        PetShopView(viewModel: PetViewModel())
    }
} 