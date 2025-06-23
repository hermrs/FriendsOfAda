import SwiftUI
import RealityKit
import Combine

struct ModelView: UIViewRepresentable {
    var petType: PetType

    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .nonAR, automaticallyConfigureSession: false)
        arView.backgroundColor = .clear
        arView.environment.background = .color(.clear)
        
        // Add a default light
        let light = DirectionalLight()
        light.light.intensity = 2000
        let lightAnchor = AnchorEntity(world: .zero)
        lightAnchor.addChild(light)
        arView.scene.addAnchor(lightAnchor)

        return arView
    }

    func updateUIView(_ arView: ARView, context: Context) {
        // Clean up previous model
        arView.scene.anchors.removeAll()

        // Load the new model using modern async/await
        Task {
            do {
                let modelEntity = try await ModelEntity(named: petType.modelName)
                
                // Get and apply model-specific configuration
                let config = petType.configuration
                modelEntity.scale = config.scale
                modelEntity.position = config.position
                modelEntity.orientation = config.rotation
                
                // Create an anchor and add the model to it.
                let modelAnchor = AnchorEntity()
                modelAnchor.addChild(modelEntity)
                arView.scene.addAnchor(modelAnchor)
                
                // Frame the camera on the model once it's ready.
                context.coordinator.frame(arView: arView, for: modelEntity)

                // Play animations
                for anim in modelEntity.availableAnimations {
                    modelEntity.playAnimation(anim.repeat(), transitionDuration: 0.5)
                }
            } catch {
                print("ERROR: Failed to load model `\(petType.modelName)`: \(error)")
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator {
        func frame(arView: ARView, for model: ModelEntity) {
            let bounds = model.visualBounds(relativeTo: nil)
            
            // Create a camera with a specific field of view.
            let camera = PerspectiveCamera()
            camera.camera.fieldOfViewInDegrees = 60
            
            // Correctly calculate the camera's distance to frame the object based on its bounding sphere.
            let halfAngle = (camera.camera.fieldOfViewInDegrees / 2.0).toRadians()
            let modelRadius = length(bounds.extents) / 2.0
            let cameraDistance = modelRadius / tan(halfAngle)
            
            // Adjust padding to a more standard value, as scale is now handled per-model.
            let paddedDistance = cameraDistance * 2.5
            
            // Position the camera to look at the center of the model.
            let cameraAnchor = AnchorEntity()
            cameraAnchor.addChild(camera)
            let modelCenter = bounds.center
            camera.look(at: modelCenter, from: [modelCenter.x, modelCenter.y, modelCenter.z + paddedDistance], relativeTo: model)
            
            // Add the camera to the scene.
            arView.scene.addAnchor(cameraAnchor)
        }
    }
}

extension Float {
    func toRadians() -> Float {
        return self * .pi / 180.0
    }
} 