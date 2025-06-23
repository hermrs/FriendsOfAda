import SwiftUI

struct WalkSummaryView: View {
    let distance: Double // in km
    let averageSpeed: Double // in km/h
    let coinsEarned: Int
    
    // Action to close the entire walk flow
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            Image(systemName: "flag.checkered.2.crossed")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Yürüyüş Tamamlandı!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(spacing: 20) {
                Text("Walk Summary")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                InfoRow(icon: "ruler", label: "Distance", value: String(format: "%.2f km", distance))
                InfoRow(icon: "speedometer", label: "Average Speed", value: String(format: "%.1f km/h", averageSpeed))
                InfoRow(icon: "bitcoinsign.circle", label: "AdaCoins Earned", value: "\(coinsEarned)")
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(15)
            
            Button(action: onClose) {
                Text("Harika!")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
        }
        .padding(40)
    }
}

// A helper view for summary rows
struct InfoRow: View {
    let icon: String
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .frame(width: 40)
                .foregroundColor(.accentColor)
            Text(label)
                .font(.headline)
            Spacer()
            Text(value)
                .font(.title3)
                .fontWeight(.medium)
        }
    }
}

struct WalkSummaryView_Previews: PreviewProvider {
    static var previews: some View {
        WalkSummaryView(distance: 1.23, averageSpeed: 4.5, coinsEarned: 60, onClose: {})
    }
} 