import SwiftUI

struct MathMinigameView: View {
    @StateObject private var viewModel = MathMinigameViewModel()
    @Environment(\.dismiss) private var dismiss
    
    // Callback to pass the result to the parent view
    var onGameComplete: (Int) -> Void
    
    var body: some View {
        VStack(spacing: 30) {
            
            // Header with Score and Close button
            HStack {
                Text("Score: \(viewModel.score)")
                    .font(.title2)
                Spacer()
                Button("Close") {
                    viewModel.finishGame()
                }
            }
            
            Image(systemName: "can.fill")
                .font(.system(size: 80))
                .foregroundColor(.gray)
            
            Text("Math Game")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Text(viewModel.question)
                .font(.title)
                .padding()
            
            HStack(spacing: 20) {
                ForEach(viewModel.answerChoices, id: \.self) { choice in
                    Button(action: {
                        viewModel.checkAnswer(choice)
                    }) {
                        Text("\(choice)")
                            .font(.largeTitle)
                            .frame(width: 80, height: 80)
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(40) // Make it circular
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            // Set the callback when the view appears
            viewModel.onGameEnd = { finalScore in
                // Pass the result to the parent
                onGameComplete(finalScore)
                
                // Dismiss the view
                dismiss()
            }
        }
    }
}

struct MathMinigameView_Previews: PreviewProvider {
    static var previews: some View {
        MathMinigameView(onGameComplete: { score in
            print("Game ended. Final score: \(score)")
        })
    }
} 
