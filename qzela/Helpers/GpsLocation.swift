//
//  GpsLocation.swift
//  qzela
//
//  Created by Edson Rocha on 29/11/21.
//

import Foundation
import CoreLocation
import UIKit

public protocol GpsLocationDelegate: AnyObject {
    func didUpdateLocation(_ sender: CLLocation)
}

public class GpsLocation: NSObject {

    public weak var delegate: GpsLocationDelegate?
    public static var shared = GpsLocation()
    
    private lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        return locationManager
    }()

    private var currentLocation: CLLocationCoordinate2D?

    public func startLocationUpdates() {
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }

    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    public func getCoordinate() -> CLLocationCoordinate2D? {
        return currentLocation
    }

    public func getLat() -> Double{
        return currentLocation?.latitude ?? 0.0
    }

    public func getLon() -> Double{
        return currentLocation?.longitude ?? 0.0
    }

 }

extension GpsLocation: CLLocationManagerDelegate {

    public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        guard let location = locations.first else { return }
        currentLocation = location.coordinate
        print("[Update location at - \(Date())] with - lat: \(currentLocation!.latitude), lng: \(currentLocation!.longitude)")
        delegate?.didUpdateLocation(location)
    }
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        case .denied:
            return
        case .restricted:
            locationManager.requestWhenInUseAuthorization()
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

}
