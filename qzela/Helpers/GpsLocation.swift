//
//  GpsLocation.swift
//  qzela
//
//  Created by Edson Rocha on 29/11/21.
//

import Foundation
import CoreLocation

class GpsLocation: NSObject, CLLocationManagerDelegate {
    
    static let shared = GpsLocation()
    
    let locationManager = CLLocationManager()
    
    var completion: ((CLLocation) ->Void)?
    
    public func getLocation(completion: @escaping ((CLLocation) -> Void)) {

        self.completion = completion
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        locationManager.startUpdatingLocation()


    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        
        completion?(location)
        locationManager.stopUpdatingLocation()
        
//        savLatitude = location.coordinate.latitude
//        savLongitude = location.coordinate.longitude
//        savCordinate =  location.coordinate
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

 }
