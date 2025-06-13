import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = PetViewModel()

    var body: some View {
        // If a pet exists, show the main game.
        if viewModel.pet != nil {
            MainGameView()
                .environmentObject(viewModel)
        } else {
            // Otherwise, show the creation screen.
            CharacterCreationView { newPet in
                viewModel.pet = newPet // Set the new pet on the view model
                // The view will automatically switch because viewModel.pet is no longer nil.
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
} 