//
//  LocationViewController.swift
//  qzela
//
//  Created by Edson Rocha on 23/02/22.
//

import UIKit
import GoogleMaps
import CoreLocation

class LocationViewController: UIViewController {

    // var to receive data from SegmentViewController
    var segmentId: Int!
    var occurrencesItem: [String] = []
    var commentary: String!
    var saveCoordinate: CLLocationCoordinate2D!

    let gpsLocation = qzela.GPSLocation()
    let fileManager = FileManager.default
    
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var btContinue: UIButton!
    
    @IBAction func btBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        print("SegmentId: \(segmentId!)")
        print("OccurrencesIds: \(occurrencesItem)")
        print("Commentary: \(String(describing: commentary))")
        // TODO: Remove after implemented Dashboard
        Config.saveIncidentPosition = 0
        if (Config.SAVED_INCIDENT) {
            let incidentImages = Config.saveIncidents[Config.saveIncidentPosition]
            saveCoordinate = CLLocationCoordinate2D(latitude: incidentImages.latitude, longitude: incidentImages.longitude)
            print("Saved Latitude: \(saveCoordinate.latitude)")
            print("Saved Longitude: \(saveCoordinate.longitude)")
            print("Saved Image type: \(incidentImages.imageType)")
            for imageSave in incidentImages.savedImages {
                print("Saved Image: \(Config.PATH_SAVED_FILES+"/"+imageSave.fileImage)")
            }
        } else {
            print("Coordinates Latitude: \(Config.savCoordinate.latitude)")
            print("Coordinates Longitude: \(Config.savCoordinate.latitude)")
            print("Image Type: \(Config.IMAGE_CAPTURED)")
            do {
                let items = try fileManager.contentsOfDirectory(atPath: Config.PATH_TEMP_FILES)
                for item in items {
                    print("Found \(Config.PATH_TEMP_FILES + "/" + item)")
                }
            } catch {
                print("Error File Path \(Config.PATH_TEMP_FILES)")
            }
        }
        addressTextField.layer.borderWidth = 2
        addressTextField.layer.cornerRadius = 12
        addressTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: addressTextField.frame.height))
        addressTextField.leftViewMode = .always
        addressTextField.isEnabled = false

        btContinue.isEnabled = false
        // Google Maps events delegate

        mapInit()
    }
    
    @IBAction func btClick(_ sender: UIButton) {
        switch sender.restorationIdentifier {
        case "btMyLocation":
            gotoMyLocation()
        case "btViewMap":
             print("btViewMap Clear Markers")
        case "btContinue":
             print("btSavedImage ShowMarkers")
        default:
            print(sender.restorationIdentifier ?? "no restoration Identifier defined")
        }
    }

    func mapInit() {
        // Load Map style from json file
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                // print("mapstyle.json Load...")
            } else {
                print("unable to find mapstyle.json")
            }
        } catch {
            print("One or more of the map styles failed to load.\(error)")
        }
        // Enable center point of my location
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(Config.MIN_ZOOM_LOCATION, maxZoom: Config.MAX_ZOOM_MAP)
        gotoMyLocation()
        mapView.delegate = self
    }

    func gotoMyLocation() {

        if (Config.SAVED_INCIDENT) {
            mapView.camera = GMSCameraPosition.camera(
                    withLatitude: saveCoordinate.latitude,
                    longitude: saveCoordinate.longitude, zoom: Config.ZOOM_INITIAL
            )
            mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                    centerCoordinate: saveCoordinate,
                    radiusInMeter: Config.LOCATION_DISTANCE
            )
        } else {
            mapView.camera = GMSCameraPosition.camera(
                    withLatitude: Config.savCoordinate.latitude,
                    longitude: Config.savCoordinate.longitude, zoom: Config.ZOOM_INITIAL
            )
            mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                    centerCoordinate: Config.savCoordinate,
                    radiusInMeter: Config.LOCATION_DISTANCE
            )
        }
    }

}

//  Events of Maps
extension LocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

         print("****** MAP IDLE *****")
    }
}
