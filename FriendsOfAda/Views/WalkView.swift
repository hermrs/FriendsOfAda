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
    @StateObject private var locationManager = LocationManager()
    @State private var isWalking = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.334_900, longitude: -122.009_020), // Default location
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    // Callback to pass the result to the parent view
    var onWalkComplete: (Double) -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Text("Parkta Yürüyüş")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()
            
            // The new MapView that wraps MKMapView
            MapView(region: $region, route: locationManager.route)
                .edgesIgnoringSafeArea(.bottom)

            VStack {
                Text(String(format: "Mesafe: %.0f metre", locationManager.distance))
                    .font(.title2)
                    .padding(.top)
                
                if !isWalking {
                    Button("Yürüyüşe Başla") {
                        isWalking = true
                        locationManager.startUpdating()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                } else {
                    Button("Yürüyüşü Bitir") {
                        isWalking = false
                        locationManager.stopUpdating()
                        onWalkComplete(locationManager.distance)
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.red)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                
                Button("Kapat") {
                    locationManager.stopUpdating()
                    dismiss()
                }
                .padding(.top, 5)
                
            }
            .padding()
            .background(Color(.systemBackground)) // Add a background to separate from map
        }
        .onAppear {
            locationManager.requestPermission()
        }
        .onChange(of: locationManager.lastLocation) { newLocation in
            // When location updates, center the map on the new location
            if let coordinate = newLocation?.coordinate {
                region.center = coordinate
            }
        }
        .navigationBarHidden(true)
    }
}


struct WalkView_Previews: PreviewProvider {
    static var previews: some View {
        WalkView(onWalkComplete: { _ in })
    }
} 