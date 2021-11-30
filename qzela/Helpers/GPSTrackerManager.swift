//
// Created by Edson Rocha on 30/11/21.
//

import Foundation
import CoreLocation

class GPSTrackingManager: NSObject, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!
    var seenError : Bool = false
    var currentLocation = CLLocationCoordinate2D()

//    override init() {
//        locationManager.requestWhenInUseAuthorization()
//
//        super.init()
//
//        if CLLocationManager.locationServicesEnabled() {
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
//        }
//    }


    func startTracking() {

        locationManager = CLLocationManager()
        if (CLLocationManager.locationServicesEnabled()) {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.activityType = . automotiveNavigation
            locationManager.distanceFilter = 10
            locationManager.startMonitoringSignificantLocationChanges()
            //        locationManager.allowsBackgroundLocationUpdates = true
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            currentLocation = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        }
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
    }

    func getLat() -> Double{
        locationManager.location?.coordinate.latitude ?? 0.0
    }

    func getLon() -> Double{
        return locationManager.location?.coordinate.longitude ?? 0.0
    }

    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error)
            }
        }
    }

    private func locationManager(manager:CLLocationManager, didUpdateLocations locations:[CLLocation]) {

        guard let location = locations.first else { return }

        if CLLocationCoordinate2DIsValid(location.coordinate) {
            print(location.coordinate)
        }
        //println("locations = \(locationManager)")
        let latValue = location.coordinate.latitude
        let lonValue = location.coordinate.longitude
//        var latValue = locationManager.location?.coordinate.latitude
//        var lonValue = locationManager.location?.coordinate.longitude

        print(latValue)
        print(lonValue)

    }
}
