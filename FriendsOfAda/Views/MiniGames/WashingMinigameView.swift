import SwiftUI

// A single particle (bubble) view
struct Particle: Identifiable {
    let id = UUID()
    var position: CGPoint
    let creationDate = Date()
}

// The main view for the washing minigame
struct WashingMinigameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PetViewModel
    var onEnd: () -> Void
    
    @State private var particles = [Particle]()
    @State private var isWashing = false
    @State private var progress: Double = 0.0

    private let petType: PetType
    
    init(viewModel: PetViewModel, onEnd: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onEnd = onEnd
        // We must have a pet to start this game, so force unwrap is acceptable here.
        self.petType = viewModel.pet!.petType
    }

    var body: some View {
        // Using a timeline view to update the animation
        TimelineView(.periodic(from: .now, by: 0.02)) { context in
            ZStack {
                // Background
                Color.blue.opacity(0.3).ignoresSafeArea()
                
                VStack {
                    Text("Evcil Hayvanını Yıka!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Köpük yapmak için üzerinde parmağını gezdir!")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    
                    ZStack {
                        // Pet Model in the center
                        ModelView(petType: petType)
                            .frame(height: 300)
                            .gesture(
                                DragGesture(minimumDistance: 0)
                                    .onChanged { value in
                                        let newParticle = Particle(position: value.location)
                                        self.particles.append(newParticle)
                                        
                                        // Increase progress while washing, ensuring it doesn't exceed 1.0
                                        if progress < 1.0 {
                                            progress = min(1.0, progress + 0.005)
                                        }
                                        HapticManager.shared.playPetting()
                                    }
                            )
                        
                        // Bubbles Overlay
                        ForEach(particles) { particle in
                            Image(systemName: "circle.fill")
                                .font(.system(size: CGFloat.random(in: 10...30)))
                                .foregroundColor(.white.opacity(0.6))
                                .position(particle.position)
                                .blur(radius: 3)
                                .transition(.opacity)
                                .id(particle.id)
                        }
                    }
                    
                    // Progress Bar
                    ProgressView("Temizlik", value: progress, total: 1.0)
                        .padding()
                        .accentColor(.green)

                    // Done Button
                    Button(action: {
                        onEnd() // Call the completion handler
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Bitti")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(progress >= 1.0 ? Color.green : Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(15)
                    }
                    .disabled(progress < 1.0)
                    .padding()
                }
                .modifier(OnChangeModifier(value: context.date) { newDate in
                    // Update particle positions and remove old ones
                    for particle in particles {
                        let timeSinceCreation = newDate.timeIntervalSince(particle.creationDate)
                        
                        // Remove particle after 1 second
                        if timeSinceCreation > 1 {
                            particles.removeAll { $0.id == particle.id }
                        } else {
                            // Move particle up
                            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                                particles[index].position.y -= 2
                            }
                        }
                    }
                })
            }
        }
    }
}

// A view modifier to handle the `onChange` deprecation warning
struct OnChangeModifier<V: Equatable>: ViewModifier {
    let value: V
    let action: (V) -> Void

    func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .onChange(of: value) { _, newValue in
                    action(newValue)
                }
        } else {
            content
                .onChange(of: value) { newValue in
                    action(newValue)
                }
        }
    }
} 