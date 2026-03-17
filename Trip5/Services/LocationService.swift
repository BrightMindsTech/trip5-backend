import Foundation
import CoreLocation
import MapKit

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published var currentLocation: CLLocation?
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = manager.authorizationStatus
    }
    
    func requestLocation() {
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    
    func reverseGeocode(coordinate: CLLocationCoordinate2D) async -> String? {
        let loc = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        do {
            let places = try await geocoder.reverseGeocodeLocation(loc)
            return places.first?.compactAddress ?? "\(coordinate.latitude), \(coordinate.longitude)"
        } catch {
            return "\(coordinate.latitude), \(coordinate.longitude)"
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            currentLocation = locations.last
        }
    }
    
    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            currentLocation = nil
        }
    }
    
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            authorizationStatus = manager.authorizationStatus
        }
    }
}

private extension CLPlacemark {
    var compactAddress: String? {
        [thoroughfare, locality, administrativeArea].compactMap { $0 }.joined(separator: ", ")
    }
}
