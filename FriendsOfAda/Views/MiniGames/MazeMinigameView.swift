import SwiftUI

struct MazeMinigameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PetViewModel
    var onGameEnd: (Int) -> Void
    
    // 1 = Wall, 0 = Path, 2 = Player, 3 = Exit, 4 = Visited Path
    @State private var maze: [[Int]] = [
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 2, 0, 1, 0, 0, 0, 0, 3, 1],
        [1, 1, 0, 1, 0, 1, 1, 1, 1, 1],
        [1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
        [1, 0, 1, 1, 1, 1, 0, 1, 0, 1],
        [1, 0, 0, 0, 0, 0, 0, 1, 0, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1]
    ]
    
    @State private var playerPosition = (row: 1, col: 1)
    @State private var gameWon = false
    
    private let cellSize: CGFloat = 30
    
    var body: some View {
        ZStack {
            VStack(spacing: 20) {
                Text("Labirent Oyunu")
                    .font(.largeTitle)
                    .padding(.top)
                
                Text("Çıkışı bul!")
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                // --- MAZE GRID ---
                VStack(spacing: 1) {
                    ForEach(0..<maze.count, id: \.self) { row in
                        HStack(spacing: 1) {
                            ForEach(0..<maze[row].count, id: \.self) { col in
                                cellView(for: maze[row][col])
                                    .frame(width: cellSize, height: cellSize)
                            }
                        }
                    }
                }
                .padding()
                .background(Color.black)
                .border(Color.black, width: 2)
                
                Spacer()
                
                // --- CONTROLS ---
                VStack(spacing: 10) {
                    Button(action: { movePlayer(direction: .up) }) {
                        Image(systemName: "arrow.up.circle.fill")
                    }
                    
                    HStack(spacing: 50) {
                        Button(action: { movePlayer(direction: .left) }) {
                            Image(systemName: "arrow.left.circle.fill")
                        }
                        Button(action: { movePlayer(direction: .right) }) {
                            Image(systemName: "arrow.right.circle.fill")
                        }
                    }
                    
                    Button(action: { movePlayer(direction: .down) }) {
                        Image(systemName: "arrow.down.circle.fill")
                    }
                }
                .font(.system(size: 60))
                .foregroundColor(.blue)
                .padding(.bottom)
            }
        }
        .alert(isPresented: $gameWon) {
            Alert(
                title: Text("Tebrikler!"),
                message: Text("Labirenti başarıyla tamamladın ve 25 AdaCoin kazandın!"),
                dismissButton: .default(Text("Harika!")) {
                    onGameEnd(25) // Pass the coin reward back
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }
    
    private func cellView(for type: Int) -> some View {
        Rectangle()
            .fill(colorForCell(type: type))
    }
    
    private func colorForCell(type: Int) -> Color {
        switch type {
        case 1: return .black // Wall
        case 2: return .green // Player
        case 3: return .yellow // Exit
        case 4: return .gray.opacity(0.5) // Visited Path
        default: return .white // Path
        }
    }
    
    private enum Direction {
        case up, down, left, right
    }
    
    private func movePlayer(direction: Direction) {
        if gameWon { return }
        
        var newRow = playerPosition.row
        var newCol = playerPosition.col
        
        switch direction {
        case .up: newRow -= 1
        case .down: newRow += 1
        case .left: newCol -= 1
        case .right: newCol += 1
        }
        
        // Check boundaries
        guard newRow >= 0, newRow < maze.count,
              newCol >= 0, newCol < maze[newRow].count else {
            return
        }
        
        // Check for walls
        guard maze[newRow][newCol] != 1 else {
            return
        }
        
        // Check for win condition
        if maze[newRow][newCol] == 3 {
            gameWon = true
            HapticManager.shared.playSuccess()
            return
        }
        
        // Update maze state
        maze[playerPosition.row][playerPosition.col] = 4 // Mark old position as visited
        playerPosition = (row: newRow, col: newCol)
        maze[playerPosition.row][playerPosition.col] = 2 // Mark new position as player
    }
}

struct MazeMinigameView_Previews: PreviewProvider {
    static var previews: some View {
        MazeMinigameView(viewModel: PetViewModel()) { coins in
            print("\(coins) coins earned!")
        }
    }
} 