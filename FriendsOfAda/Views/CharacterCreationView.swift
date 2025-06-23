import SwiftUI
import RealityKit

struct CharacterCreationView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String = ""
    @State private var petType: PetType = .cat
    @State private var color: Color = .brown
    
    // This closure will be called when the user finishes creation
    var onPetCreated: (Pet) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Choose Your Pet!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            ModelView(petType: petType)
                .frame(height: 300)
                .padding()
            
            Form {
                Section(header: Text("Name")) {
                    TextField("What should be your pet's name?", text: $name)
                }
                
                Section(header: Text("Type")) {
                    Picker("Choose a pet", selection: $petType) {
                        ForEach(PetType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Color")) {
                    ColorPicker("Select a color", selection: $color)
                }
            }
            
            Button(action: createPet) {
                Text("Start Adventure!")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(name.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(name.isEmpty)
            .padding()
        }
    }
    
    private func createPet() {
        let cgColor = UIColor(color).cgColor
        let components = cgColor.components ?? [0, 0, 0]
        let codableColor = CodableColor(red: components[0], green: components[1], blue: components[2])
        
        let newPet = Pet(name: name, petType: petType, color: codableColor)
        onPetCreated(newPet)
    }
}

struct CharacterCreationView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterCreationView(onPetCreated: { _ in })
    }
} 