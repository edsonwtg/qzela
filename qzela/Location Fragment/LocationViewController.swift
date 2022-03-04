//
//  LocationViewController.swift
//  qzela
//
//  Created by Edson Rocha on 23/02/22.
//

import UIKit
import GoogleMaps
import CoreLocation
import Contacts
import Alamofire

class LocationViewController: UIViewController {

    // var to receive data from SegmentViewController
    var segmentId: Int!
    var occurrencesItem: [String] = []
    var commentary: String!
    var saveCoordinate: CLLocationCoordinate2D!

    var resultMar = [NSDictionary()]

    struct Geocoding: Codable {
        var completeAddress: String = ""
        var address: String = ""
        var number: String = ""
        var country: String = ""
        var state: String = ""
        var city: String = ""
        var district: String = ""
        var postalCode: String = ""
        var inlandWater: String = ""
        var ocean: String = ""
        var areasOfInterest: [String] = []
    }
    var appleGeocoding = Geocoding()
    var googleGeocoding = Geocoding()
    var webGeocoding = Geocoding()
    var addressGeocoding = Geocoding()

    let networkListener = NetworkListener()
    let gpsLocation = qzela.GPSLocation()
    let fileManager = FileManager.default

    let geocoderApple = CLGeocoder()
    let geocoderGoogle = GMSGeocoder()

    let dispatchGroupGeocoding = DispatchGroup()
    
    
    @IBOutlet weak var addressTextView: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var markerImageView: UIImageView!
    @IBOutlet weak var btContinue: UIButton!
    
   @IBAction func btBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO: Remove after test
        segmentId = 6
        occurrencesItem.append("5d987a1f2d9c3f7efcbaa413")
        occurrencesItem.append("5d987a1f2d9c3f7efcbaa413")
        // Home
        Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.613102550188003, longitude: -46.68283302336931)
        // Rua Florida, 1758
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude:-23.6072598, longitude: -46.6951241)
        // **************
        print("SegmentId: \(segmentId!)")
        print("OccurrencesIds: \(occurrencesItem)")
        print("Commentary: \(String(describing: commentary))")

        // TODO: Remove after implemented Dashboard
        Config.saveIncidentPosition = 0
        // **************
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
        addressTextView.layer.borderWidth = 2
        addressTextView.layer.cornerRadius = 12
        addressTextView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 20)
        addressTextView.isEditable = false

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
//        mapView.setMinZoom(Config.MIN_ZOOM_LOCATION, maxZoom: Config.MAX_ZOOM_MAP)
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
//            mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
//                    centerCoordinate: Config.savCoordinate,
//                    radiusInMeter: Config.LOCATION_DISTANCE
//            )
        }
    }

    func getGoogleAddress(coordinates: CLLocationCoordinate2D) {

        dispatchGroupGeocoding.enter()

        geocoderGoogle.reverseGeocodeCoordinate(coordinates) {response, error in
            if error != nil {
                print("reverse geodcode fail: \(error!.localizedDescription)")
            } else {
                if let places = response?.results() {
                    if let place = places.first {
                        self.googleGeocoding.completeAddress = place.lines?[0] ?? ""
                        self.googleGeocoding.address = place.thoroughfare ?? ""
                        self.googleGeocoding.number = ""
                        self.googleGeocoding.country = place.country ?? ""
                        self.googleGeocoding.state = place.administrativeArea ?? ""
                        self.googleGeocoding.city =  ""
                        self.googleGeocoding.district = place.subLocality ?? ""
                        self.googleGeocoding.postalCode = place.postalCode ?? ""
                        self.googleGeocoding.inlandWater =  ""
                        self.googleGeocoding.ocean =  ""
                        self.googleGeocoding.areasOfInterest = []
                    } else {
                        print("GEOCODE: nil first in places")
                    }
                } else {
                    print("GEOCODE: nil in places")
                    self.googleGeocoding = Geocoding()
                }
                print("************ GOOGLE GEOCODING ***************")
                print("Endereço Completo: \(self.googleGeocoding.completeAddress)");
                print("Endereço: \(self.googleGeocoding.address)");
                print("Numero: \(self.googleGeocoding.number)");
                print("Pais: \(self.googleGeocoding.country)");
                print("Estado: \(self.googleGeocoding.state)");
                print("Cidade: \(self.googleGeocoding.city)");
                print("Bairro: \(self.googleGeocoding.district)");
                print("CEP: \(self.googleGeocoding.postalCode)")
                print("Land or Water: \(self.googleGeocoding.inlandWater)")
                print("OCEAN/RIO: \(self.googleGeocoding.ocean)")
                print("Areas of Interest:  \(self.googleGeocoding.areasOfInterest)")
                self.dispatchGroupGeocoding.leave()
            }
        }
    }

    func getAppleAddress(coordinates: CLLocation) {

        dispatchGroupGeocoding.enter()

        geocoderApple.reverseGeocodeLocation(coordinates, preferredLocale: Locale.init(identifier: "pt_BR")) { placemarks, error in
            if (error != nil) {
                print("Reverse geocoder failed with error" + (error?.localizedDescription)!)
                return
            }
            if (placemarks?.count)! > 0 {
                let pm = placemarks?[0]
                self.appleGeocoding.address = pm?.thoroughfare ?? ""
                self.appleGeocoding.number = pm?.subThoroughfare ?? "s/n"
                self.appleGeocoding.country = pm?.country ?? ""
                self.appleGeocoding.state = pm?.administrativeArea ?? ""
                self.appleGeocoding.city = pm?.locality ?? ""
                self.appleGeocoding.district = pm?.subLocality ?? ""
                self.appleGeocoding.postalCode = pm?.postalCode ?? ""
                self.appleGeocoding.inlandWater = pm?.inlandWater ?? ""
                self.appleGeocoding.ocean = pm?.ocean ?? ""
                self.appleGeocoding.areasOfInterest = pm?.areasOfInterest ?? []

                let postalAddressFormatter = CNPostalAddressFormatter()
                postalAddressFormatter.style = .mailingAddress
                var addressString: String?
                if let postalAddress = pm?.postalAddress {
                    addressString = postalAddressFormatter.string(from: postalAddress)
                    addressString = addressString?.replacingOccurrences(of: "\n", with: " - ")
                    self.appleGeocoding.completeAddress = addressString ?? ""
                } else {
                    self.appleGeocoding.completeAddress = pm?.name ?? ""
                }
            } else {
                print("Problem with the data received from geocoder")
            }
            self.dispatchGroupGeocoding.leave()
        }
    }

    func getWebGoogleAddress(latitude: Double, longitude : Double) {

        dispatchGroupGeocoding.enter()

        let url = Config.GOOGLE_GEOCODING_URL + "&latlng=\(latitude),\(longitude)" + "&key=" + Config.GOOGLE_API_KEY
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let responseJson = try JSONSerialization.jsonObject(with: data) as! NSDictionary
                    if let results = responseJson.object(forKey: "results")! as? [NSDictionary] {
                        if results.count > 0 {
                            if let addressComponents = results[0]["address_components"]! as? [NSDictionary] {
                                if (addressComponents.count > 1) {
                                    self.webGeocoding.completeAddress = results[0]["formatted_address"] as! String
                                    for component in addressComponents {
                                        let type = component["types"] as! Array<String>
                                        if (type.contains("street_number")) {
                                            self.webGeocoding.number = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("route")) {
                                            self.webGeocoding.address = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("country")) {
                                            self.webGeocoding.country = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("administrative_area_level_1")) {
                                            self.webGeocoding.state = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("administrative_area_level_2")) {
                                            self.webGeocoding.city = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("sublocality")) {
                                            self.webGeocoding.district = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("postal_code")) {
                                            self.webGeocoding.postalCode = component.value(forKey: "long_name") as! String
                                        }
                                        if (type.contains("point_of_interest")) {
                                            self.webGeocoding.areasOfInterest.append(component.value(forKey: "long_name") as! String)
                                        }
                                    }
                                    self.webGeocoding.inlandWater =  ""
                                    self.webGeocoding.ocean =  ""
                                    self.webGeocoding.areasOfInterest = []
                                }
                            }
                        }
                    }
                } catch {
                    print("Error while decoding response")
                }
            case .failure(let error):
                print(error)
            }
            self.dispatchGroupGeocoding.leave()
        }
    }

}

//  Events of Maps
extension LocationViewController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        // print("****** MAP IDLE *****")
        let location = CLLocation(latitude: position.target.latitude, longitude: position.target.longitude)
        // print(location.coordinate.latitude)
        // print(location.coordinate.longitude)
        if (!networkListener.isNetworkAvailable()) {
            // print("******** NO INTERNET CONNECTION *********")
            showAlert(title: "text_no_internet".localized(),
                    message: "text_internet_off".localized(),
                    type: .attention,
                    actionTitles: ["text_got_it".localized()],
                    style: [.default],
                    actions: [nil])
            return
        }
        appleGeocoding = Geocoding()
        webGeocoding = Geocoding()

        getAppleAddress(coordinates: location)
        getWebGoogleAddress(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)

        dispatchGroupGeocoding.notify(queue: .main) {
            DispatchQueue.main.async {
                self.addressGeocoding = Geocoding()
                self.addressTextView.text = ""

                if (self.appleGeocoding.areasOfInterest.count > 0 || self.appleGeocoding.areasOfInterest.count > 0) {
                    if (self.appleGeocoding.areasOfInterest.count > 0) {
                        print("*****************************************")
                        print("Areas of Interest Apple:  \(self.appleGeocoding.areasOfInterest)")
                        self.addressGeocoding.areasOfInterest = self.appleGeocoding.areasOfInterest
                        print("*****************************************")
                    } else {
                        print("*****************************************")
                        print("Areas of Interest Web:  \(self.webGeocoding.areasOfInterest)")
                        self.addressGeocoding.areasOfInterest = self.webGeocoding.areasOfInterest
                        print("*****************************************")
                    }
                }
                if (self.appleGeocoding.inlandWater != "") {
                    print("*****************************************")
                    print("Rios e Lagos:  \(self.appleGeocoding.inlandWater)")
                    self.addressGeocoding.inlandWater = self.appleGeocoding.inlandWater
                    print("*****************************************")
                }
                if (self.appleGeocoding.ocean != "") {
                    print("*****************************************")
                    print("Oceano:  \(self.appleGeocoding.ocean)")
                    self.addressGeocoding.ocean = self.appleGeocoding.ocean
                    self.addressTextView.text = self.appleGeocoding.ocean
                    print("*****************************************")
                } else {
                    if (self.appleGeocoding.address == "" && self.webGeocoding.address == "") {
                        let okActionHandler: (UIAlertAction) -> Void = {(action) in
                            print("*** NO ADDRESS ***")
                        }
                        self.showAlert(title:  "text_no_address".localized(),
                                message: "text_enter_address".localized(),
                                type: .attention,
                                actionTitles: ["text_cancel".localized(), "text_ok".localized()],
                                style: [.cancel, .default],
                                actions: [nil, okActionHandler])
                    } else {
                        if (self.appleGeocoding.address != "") {
                            print("Endereço Apple: \(self.appleGeocoding.address)");
                            self.addressGeocoding.address = self.appleGeocoding.address
                            self.addressTextView.text = self.appleGeocoding.completeAddress
                        } else {
                            print("Endereço Web: \(self.webGeocoding.address)");
                            self.addressGeocoding.address = self.webGeocoding.address
                            self.addressTextView.text = self.webGeocoding.completeAddress
                        }
                        if (self.appleGeocoding.number != "") {
                            print("Numero Apple: \(self.appleGeocoding.number)");
                            self.addressGeocoding.number = self.appleGeocoding.number
                        } else {
                            print("Numero Web: \(self.webGeocoding.number)");
                            self.addressGeocoding.number = self.webGeocoding.number
                        }
                        if (self.appleGeocoding.country != "") {
                            print("Pais Apple: \(self.appleGeocoding.country)");
                            self.addressGeocoding.country = self.appleGeocoding.country
                        } else {
                            print("Pais Web: \(self.webGeocoding.country)");
                            self.addressGeocoding.country = self.webGeocoding.country
                        }
                        if (self.appleGeocoding.state != "") {
                            print("Estado Apple: \(self.appleGeocoding.state)");
                            self.addressGeocoding.state = self.appleGeocoding.state
                        } else {
                            print("Estado Web: \(self.webGeocoding.state)");
                            self.addressGeocoding.state = self.webGeocoding.state
                        }
                        if (self.appleGeocoding.city != "") {
                            print("Cidade Apple: \(self.appleGeocoding.city)");
                            self.addressGeocoding.city = self.appleGeocoding.city
                        } else {
                            print("Cidade Web: \(self.webGeocoding.city)");
                            self.addressGeocoding.city = self.webGeocoding.city
                        }
                        if (self.appleGeocoding.district != "") {
                            print("Bairro Apple: \(self.appleGeocoding.district)");
                            self.addressGeocoding.district = self.appleGeocoding.district
                        } else {
                            print("Bairro Web: \(self.webGeocoding.district)");
                            self.addressGeocoding.district = self.webGeocoding.district
                        }
                        if (self.appleGeocoding.postalCode != "") {
                            if (self.appleGeocoding.postalCode.count == 5 ) {
                                self.appleGeocoding.postalCode = self.appleGeocoding.postalCode + "-000"
                            }
                            print("CEP Apple: \(self.appleGeocoding.postalCode)");
                            self.addressGeocoding.postalCode = self.appleGeocoding.postalCode
                        } else {
                            print("CEP Web: \(self.webGeocoding.postalCode)");
                            self.addressGeocoding.postalCode = self.webGeocoding.postalCode
                        }
//                        print("************ APPLE GEOCODING ***************")
//                        print("Endereço Completo: \(self.appleGeocoding.completeAddress)");
//                        print("Land or Water: \(self.appleGeocoding.inlandWater)")
//                        print("OCEAN/RIO: \(self.appleGeocoding.ocean)")
//                        print("Areas of Interest:  \(self.appleGeocoding.areasOfInterest)")
//
//                        print("************ WEB GEOCODING ***************")
//                        print("Endereço Completo: \(self.webGeocoding.completeAddress)");
//                        print("Areas of Interest:  \(self.webGeocoding.areasOfInterest)")
                    }
                }
            }
        }
    }
}