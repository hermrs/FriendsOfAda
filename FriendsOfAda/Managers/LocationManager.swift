import Foundation
import CoreLocation
import Combine

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    
    static let shared = LocationManager() // Singleton instance
    
    private let manager = CLLocationManager()
    
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?
    @Published var route: [CLLocationCoordinate2D] = []
    @Published var distance: Double = 0.0 // in meters
    @Published var speed: Double = 0.0 // in km/h
    @Published var averageSpeed: Double = 0.0 // in km/h
    
    private var lastLocationForDistanceCalc: CLLocation?
    private var walkStartTime: Date?
    
    private override init() { // Make init private
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestPermission() {
        manager.requestWhenInUseAuthorization()
    }
    
    func startUpdating() {
        route.removeAll()
        distance = 0.0
        speed = 0.0
        averageSpeed = 0.0
        lastLocationForDistanceCalc = nil
        walkStartTime = Date() // Record start time
        manager.startUpdatingLocation()
    }
    
    func stopUpdating() {
        manager.stopUpdatingLocation()
        walkStartTime = nil
    }
    
    // MARK: - Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        
        // Speed is valid only if it's a positive value
        if location.speed >= 0 {
            self.speed = location.speed * 3.6 // convert m/s to km/h
        }
        
        // Only add to route if the location has horizontal accuracy
        if location.horizontalAccuracy < 20 { // Filter out inaccurate points
            route.append(location.coordinate)
            
            if let last = lastLocationForDistanceCalc {
                distance += location.distance(from: last)
            }
            lastLocationForDistanceCalc = location
        }
        
        // Calculate average speed
        if let startTime = walkStartTime {
            let duration = Date().timeIntervalSince(startTime)
            if duration > 0 && distance > 0 {
                let avgSpeedInMps = distance / duration
                self.averageSpeed = avgSpeedInMps * 3.6 // convert m/s to km/h
            }
        }
    }
} 