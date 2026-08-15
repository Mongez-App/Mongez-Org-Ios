import Foundation
import Combine
import CoreLocation

public final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published public var userLocation: CLLocationCoordinate2D?
    @Published public var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published public var errorMessage: String?

    private let locationManager = CLLocationManager()

    public override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        authorizationStatus = locationManager.authorizationStatus
    }

    public func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }

    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            DispatchQueue.main.async { [weak self] in
                self?.errorMessage = "Location access is required to select your organization location."
                self?.stopUpdatingLocation()
            }
        default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }

        DispatchQueue.main.async { [weak self] in
            self?.userLocation = coordinate
            self?.stopUpdatingLocation()
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async { [weak self] in
            self?.errorMessage = error.localizedDescription
            self?.stopUpdatingLocation()
        }
    }
}
