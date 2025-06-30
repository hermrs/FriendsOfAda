import SwiftUI

// The main view for the loving minigame
struct LovingMinigameView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: PetViewModel
    var onEnd: () -> Void
    
    // Using the same particle system, but we'll render them as hearts
    @State private var particles = [Particle]()
    @State private var progress: Double = 0.0

    private let petType: PetType
    
    init(viewModel: PetViewModel, onEnd: @escaping () -> Void) {
        self.viewModel = viewModel
        self.onEnd = onEnd
        // We must have a pet to start this game, so force unwrap is acceptable here.
        self.petType = viewModel.pet!.petType
    }

    var body: some View {
        TimelineView(.periodic(from: .now, by: 0.02)) { context in
            ZStack {
                // Background
                Color.pink.opacity(0.2).ignoresSafeArea()
                
                VStack {
                    Text("Love Your Pet!")
                        .font(.largeTitle)
                        .padding()
                    
                    Text("Move your finger over it to release hearts!")
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
                                        
                                        // Increase progress while loving, ensuring it doesn't exceed 1.0
                                        if progress < 1.0 {
                                            progress = min(1.0, progress + 0.005)
                                        }
                                        HapticManager.shared.playPetting()
                                    }
                            )
                        
                        // Hearts Overlay
                        ForEach(particles) { particle in
                            Image(systemName: "heart.fill")
                                .font(.system(size: CGFloat.random(in: 15...35)))
                                .foregroundColor(.pink.opacity(0.7))
                                .position(particle.position)
                                .transition(.opacity)
                                .id(particle.id)
                        }
                    }
                    
                    // Progress Bar
                    ProgressView("Love", value: progress, total: 1.0)
                        .padding()
                        .accentColor(.pink)

                    // Done Button
                    Button(action: {
                        onEnd() // Call the completion handler
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Done")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(progress >= 1.0 ? Color.pink : Color.gray)
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
                        
                        if timeSinceCreation > 0.8 {
                            particles.removeAll { $0.id == particle.id }
                        } else {
                            if let index = particles.firstIndex(where: { $0.id == particle.id }) {
                                particles[index].position.y -= 2.5 // Hearts rise a bit faster
                            }
                        }
                    }
                })
            }
        }
    }
} 