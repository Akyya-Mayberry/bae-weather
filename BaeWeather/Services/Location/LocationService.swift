//
//  LocationViewModel.swift
//  OnrampProject
//
//  Created by hollywoodno on 3/10/20.
//

import Foundation
import CoreLocation

protocol LocationServiceDelegate {
    func locationService(_ locationService: LocationService, didUpdateLocationAuthorization status: LocationStatusUpdate)
    func locationService(_ locationService: LocationService, didFailWith error: Error)
}

enum LocationStatusUpdate {
    case authorized, denied, notDetermined
}

class LocationService: NSObject {
    
    // MARK: - Properties
    
    static let sharedInstance = LocationService()
    
    let locationManager = CLLocationManager()
    var delegate: LocationServiceDelegate?
    
    var requestStatus: LocationStatusUpdate {
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            return .authorized
        case .restricted, .denied:
            return .denied
        default:
            return .notDetermined
        }
    }
    
    var currentLocation: (lat: Double, long: Double)? {
        guard let location = getCurrentLocation() else {
            return nil
        }
        
        return (location.coordinate.latitude, location.coordinate.longitude)
    }
    
    // MARK: - Methods
    
    private override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getCurrentLocation() -> CLLocation? {
        return locationManager.location
    }
    
    /*
     Converts CLLocation object to CLPlacemark for human readable city and state info
     **/
    func getCurrentLocationAsPlacemark() -> CLPlacemark? {
        return nil
    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

// MARK: - Extensions

extension LocationService: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            delegate?.locationService(self, didUpdateLocationAuthorization: .authorized)
        case .restricted, .denied:
            delegate?.locationService(self, didUpdateLocationAuthorization: .denied)
        case .notDetermined:
            delegate?.locationService(self, didUpdateLocationAuthorization: .notDetermined)
        default:
            delegate?.locationService(self, didUpdateLocationAuthorization: .notDetermined)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        delegate?.locationService(self, didFailWith: error)
    }
}
