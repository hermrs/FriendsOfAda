import SwiftUI

struct CharacterCreationView: View {
    @State private var name: String = ""
    @State private var petType: PetType = .dog
    @State private var color: Color = .brown
    
    // This closure will be called when the user finishes creation
    var onPetCreated: (Pet) -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Evcil Hayvanını Yarat!")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            Image(systemName: petType.iconName)
                .font(.system(size: 100))
                .foregroundColor(color)
            
            Form {
                Section(header: Text("İsim")) {
                    TextField("Evcil hayvanının adı ne olsun?", text: $name)
                }
                
                Section(header: Text("Tür")) {
                    Picker("Tür Seç", selection: $petType) {
                        ForEach(PetType.allCases, id: \.self) { type in
                            Text(type.rawValue.capitalized).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                
                Section(header: Text("Renk")) {
                    ColorPicker("Bir renk seç", selection: $color)
                }
            }
            
            Button(action: createPet) {
                Text("Maceraya Başla!")
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