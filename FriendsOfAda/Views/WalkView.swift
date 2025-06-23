import SwiftUI
import MapKit

// A wrapper around MKMapView to use in SwiftUI
struct MapView: UIViewRepresentable {
    
    // The region to display
    @Binding var region: MKCoordinateRegion
    // The route to draw on the map
    var route: [CLLocationCoordinate2D]

    // Creates the initial MKMapView
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.setRegion(region, animated: false)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    // Updates the view when the state changes
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // Update the visible region
        if uiView.region.center.latitude != region.center.latitude || uiView.region.center.longitude != region.center.longitude {
            uiView.setRegion(region, animated: true)
        }
        
        // Remove old overlays and add the new route
        uiView.removeOverlays(uiView.overlays)
        if !route.isEmpty {
            let polyline = MKPolyline(coordinates: route, count: route.count)
            uiView.addOverlay(polyline)
        }
    }

    // Creates the coordinator to handle delegate methods
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    // Coordinator class to act as the map view's delegate
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView

        init(_ parent: MapView) {
            self.parent = parent
        }
        
        // Provides the renderer for the polyline overlay
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if let polyline = overlay as? MKPolyline {
                let renderer = MKPolylineRenderer(polyline: polyline)
                renderer.strokeColor = .systemBlue
                renderer.lineWidth = 5
                return renderer
            }
            return MKOverlayRenderer(overlay: overlay)
        }
    }
}

struct WalkView: View {
    @StateObject private var locationManager = LocationManager.shared
    @EnvironmentObject var viewModel: PetViewModel // Get viewModel from environment
    
    @State private var isWalking = false
    @State private var showSummary = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    
    var body: some View {
        ZStack(alignment: .bottom) {
            MapView(region: $region, route: locationManager.route)
                .edgesIgnoringSafeArea(.all)

            VStack {
                // Live Stats "Island"
                VStack(spacing: 10) {
                    let distanceInKm = locationManager.distance / 1000.0
                    
                    HStack(alignment: .center, spacing: 20) {
                        StatItem(value: String(format: "%.2f", distanceInKm), unit: "km", label: "Distance")
                        Divider().background(Color.white.opacity(0.5)).frame(height: 40)
                        StatItem(value: String(format: "%.1f", locationManager.speed), unit: "km/h", label: "Speed")
                        Divider().background(Color.white.opacity(0.5)).frame(height: 40)
                        StatItem(value: String(format: "%.1f", locationManager.averageSpeed), unit: "km/h", label: "Avg. Speed")
                    }
                }
                .padding()
                .background(Color.black.opacity(0.6))
                .cornerRadius(20)
                .padding(.horizontal)
                
                Spacer()

                // Start/Stop Button
                if !isWalking {
                    Button("Yürüyüşe Başla") {
                        isWalking = true
                        locationManager.startUpdating()
                    }
                    .buttonStyle(WalkButtonStyle(color: .green))
                } else {
                    Button("Yürüyüşü Bitir") {
                        isWalking = false
                        locationManager.stopUpdating()
                        viewModel.walkPet(distanceInMeters: locationManager.distance)
                        showSummary = true
                    }
                    .buttonStyle(WalkButtonStyle(color: .red))
                }
            }
            .padding(.bottom, 40)
        }
        .onAppear {
            if let userLocation = locationManager.lastLocation?.coordinate {
                region.center = userLocation
            }
        }
        .sheet(isPresented: $showSummary) {
            let reward = viewModel.calculateWalkReward(distanceInMeters: locationManager.distance)
            WalkSummaryView(
                distance: locationManager.distance / 1000.0,
                averageSpeed: locationManager.averageSpeed,
                coinsEarned: reward.coins,
                onClose: {
                    showSummary = false
                    dismiss()
                }
            )
        }
    }
}

// MARK: - Helper Views & Styles

struct StatItem: View {
    let value: String
    let unit: String
    let label: String
    
    var body: some View {
        VStack {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                Text(value)
                    .font(.system(size: 28, weight: .bold))
                Text(unit)
                    .font(.system(size: 14, weight: .semibold))
                    .offset(y: -2)
            }
            Text(label)
                .font(.caption)
                .textCase(.uppercase)
        }
        .foregroundColor(.white)
    }
}

struct WalkButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .fontWeight(.bold)
            .padding()
            .frame(maxWidth: .infinity)
            .background(color)
            .foregroundColor(.white)
            .cornerRadius(15)
            .padding(.horizontal)
            .scaleEffect(configuration.isPressed ? 0.97 : 1.0)
    }
}

struct WalkView_Previews: PreviewProvider {
    static var previews: some View {
        WalkView()
            .environmentObject(PetViewModel())
    }
} 