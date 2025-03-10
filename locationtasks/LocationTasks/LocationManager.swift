//
//  LocationManager.swift
//  LocationTasks
//
//  Created by Abdalla Abdelmagid on 11/5/24.
//

import CoreLocation
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func centerOnUser() {
        if let location = manager.location?.coordinate {
            region.center = location
        }
    }
    
    func convertToCoordinate(_ point: CGPoint) -> CLLocationCoordinate2D? {
        let rect = UIScreen.main.bounds
        let normalizedPoint = CGPoint(
            x: point.x / rect.width,
            y: point.y / rect.height
        )
        
        let span = region.span
        let centerCoordinate = region.center
        
        let latitude = centerCoordinate.latitude + (0.5 - normalizedPoint.y) * span.latitudeDelta
        let longitude = centerCoordinate.longitude + (normalizedPoint.x - 0.5) * span.longitudeDelta
        
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            region.center = location.coordinate
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location manager failed with error: \(error.localizedDescription)")
    }
}
