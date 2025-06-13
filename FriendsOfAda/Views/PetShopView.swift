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
                Button("Kapat") {
                    dismiss()
                }
            }
            
            HStack {
                Image(systemName: "bitcoinsign.circle.fill")
                Text("AdaCoins: \(viewModel.pet.adaCoins)")
            }
            .font(.title2)
            .foregroundColor(.orange)

            Spacer()
            
            VStack(spacing: 20) {
                Text("Ürünler")
                    .font(.title)
                
                Button(action: {
                    viewModel.buyFood()
                }) {
                    HStack {
                        Image(systemName: "fork.knife")
                        Text("Mama Satın Al (15 Coin)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button(action: {
                    viewModel.buyWater()
                }) {
                    HStack {
                        Image(systemName: "drop.fill")
                        Text("Su Satın Al (10 Coin)")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            
            Spacer()
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