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
        // TODO: Home location for development test
//        let coor = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
        let coor = locationManager.location?.coordinate ?? CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0)
        print("GET Coordenate: \(coor)")
        return coor
    }

    func getLat() -> Double{
        // TODO: Home location for development test
//        let lat = -23.612992
        let lat = locationManager.location?.coordinate.latitude ?? 0.0
        print("Latitude: \(lat)")
        return lat
    }

    func getLon() -> Double{
        // TODO: Home location for development test
//        let lon = -46.682762
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

    func reduceBounds(bounds: GMSCoordinateBounds, percentage: Double)-> GMSCoordinateBounds? {
        let north: Double = bounds.northEast.latitude
        let south: Double = bounds.southWest.latitude
        let east: Double = bounds.northEast.longitude
        let west: Double = bounds.southWest.longitude
        let lowerFactor: Double = percentage / 2 / 100
        let upperFactor: Double = (100 - percentage / 2) / 100
        return GMSCoordinateBounds(
                coordinate: CLLocationCoordinate2D(latitude: south + (north - south) * lowerFactor, longitude: west + (east - west) * lowerFactor),
                coordinate: CLLocationCoordinate2D(latitude: south + (north - south) * upperFactor, longitude: west + (east - west) * upperFactor))
    }

    func increaseBounds(bounds: GMSCoordinateBounds, percentage: Double)-> GMSCoordinateBounds? {
        let increasePercentage: Double = 1 + (percentage / 100);
        let northeast = bounds.northEast
        let southwest = bounds.southWest

        let latAdjustment: Double = (northeast.latitude - southwest.latitude) * (increasePercentage - 1)
        let lngAdjustment: Double = (northeast.longitude - southwest.longitude) * (increasePercentage - 1)
        let newPointNorthEast: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: northeast.latitude + latAdjustment, longitude: northeast.longitude + lngAdjustment)
        let newPointSouthWest: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: southwest.latitude - latAdjustment, longitude: southwest.longitude - lngAdjustment)

        return GMSCoordinateBounds(coordinate: newPointNorthEast,coordinate: newPointSouthWest)
    }

    func getDistanceInMeters(coordinateOrigin: CLLocationCoordinate2D, coordinateDestiny: CLLocationCoordinate2D  ) -> Double {

        Double(CLLocation(
                latitude: coordinateOrigin.latitude,
                longitude: coordinateOrigin.longitude)
                .distance( from: CLLocation(
                        latitude: coordinateDestiny.latitude,
                        longitude: coordinateDestiny.longitude)
                )
        )
        // result is in meters
        }

    func getAccuracy() -> Double {

        locationManager.location?.horizontalAccuracy ?? 0
    }

    func isGpsEnable() -> Bool {
        var hasPermission = false
        let manager = CLLocationManager()

        if CLLocationManager.locationServicesEnabled() {
            switch manager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                hasPermission = false
            case .authorizedAlways, .authorizedWhenInUse:
                hasPermission = true
            @unknown default:
                break
            }
        } else {
            hasPermission = false
        }
        
        if (locationManager.location!.horizontalAccuracy < 0){
            print("no signal");
        }
        else if (locationManager.location!.horizontalAccuracy > 163){
            print("poor signal");
        }
        else if (locationManager.location!.horizontalAccuracy > 48){
            print("average signal");
        }
        else{
            print("full signal");
        }


        return hasPermission
    }

   internal func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        guard let location = locations.first else { return }

        print("****** UPDATE LOCATION ******* Coord.: \(location.coordinate)")

        // here we call it for closure:
        updatedLocations?(locations)

        // calling the delegate method for Protocol
        delegate?.GPSLocation(didUpdate: locations)
   }
    
    internal func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {

        guard let region1 = region else { return }
        print(" ****** monitoringDidFailFor Region: \(region1) - Error: \(error)")
      }

    private func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        guard let erro = error else { return }
        print(" ****** didFailWithError Error: \(erro)")
        locationManager.stopUpdatingLocation()
    }

    internal func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {

        print(" ****** didChangeAuthorization Status: \(status)")
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
