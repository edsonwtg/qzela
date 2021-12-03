//
// Created by Edson Rocha on 30/11/21.
//

import Foundation
import CoreLocation
import MapKit
import GoogleMaps

protocol GPSLocationDelegate: AnyObject {
    func GPSLocation(didUpdate locations: [CLLocation])
}

class GPSLocation: NSObject, CLLocationManagerDelegate {

    let locationManager = CLLocationManager()
    var seenError : Bool = false
    var currentLocation = CLLocationCoordinate2D()

    // here is the closure
    var updatedLocations: (([CLLocation]) -> Void)?

    // here is the delegate with Protocol:
    weak var delegate: GPSLocationDelegate?

    override init() {
        super.init()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters
            locationManager.requestAlwaysAuthorization()
//            locationManager.startUpdatingLocation()
        }
    }

    public func startLocationUpdates() {
        print("")
        locationManager.startUpdatingLocation()
    }

    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
    }

    func getCoordinate() -> CLLocationCoordinate2D? {
        let coor = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        print("Coordenate: \(coor)")
        return coor
    }

    func getLat() -> Double{
        let lat = locationManager.location?.coordinate.latitude ?? 0.0
        print("Latitude: \(lat)")
        return lat
    }

    func getLon() -> Double{
        let lon = locationManager.location?.coordinate.longitude ?? 0.0
        print("Longitude: \(lon)")
        return lon
    }

    func getLatLngBounds(centerCoordinate: CLLocationCoordinate2D, radiusInMeter: Double) -> GMSCoordinateBounds? {

        let region = MKCoordinateRegion(center: centerCoordinate, latitudinalMeters: radiusInMeter*2, longitudinalMeters: radiusInMeter*2)
        let southWest = CLLocationCoordinate2DMake(
                region.center.latitude - region.span.latitudeDelta/2,
                region.center.longitude - region.span.longitudeDelta/2
        )
        let northEast = CLLocationCoordinate2DMake(
                region.center.latitude + region.span.latitudeDelta/2,
                region.center.longitude + region.span.longitudeDelta/2
        )
        return GMSCoordinateBounds(coordinate: northEast, coordinate: southWest)

    }

    func getDistanceInMeters(coordinateOrigin: CLLocation, coordinateDestiny: CLLocation  ) -> Float {

        Float(coordinateOrigin.distance(from: coordinateDestiny)) // result is in meters
    }

    func getAccuracy() -> Double {

        locationManager.location?.horizontalAccuracy ?? 0
    }

   internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }

        // here we call it for closure:
        updatedLocations?(locations)

        // calling the delegate method for Protocol
        delegate?.GPSLocation(didUpdate: locations)

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

    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        locationManager.stopUpdatingLocation()
        if ((error) != nil) {
            if (seenError == false) {
                seenError = true
                print(error!)
            }
        }
    }

    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

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


}
