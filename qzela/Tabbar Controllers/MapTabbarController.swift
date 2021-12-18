//
//  MapTabbarController.swift
//  qzela
//
//  Created by Edson Rocha on 19/11/21.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation
import FirebaseStorage
import Apollo


class MapTabbarController: UIViewController {

    let config = Config()
    var gpsLocation = qzela.GPSLocation()
    var networkListener = NetworkListener()
    var alreadyGetIncidents: Array<String> = []
    var markerIcon: Array<GMSMarker> = []
    var markerCircle: Array<GMSMarker> = []
    var segmentIcon: [Int: UIImage] = [:]

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbQzelaPoints: UILabel!
    @IBOutlet weak var ivNoInternet: UIImageView!
    @IBOutlet weak var ivNoGps: UIImageView!
    @IBOutlet weak var btMyLocation: UIButton!
    @IBOutlet weak var btViewMap: UIButton!
    @IBOutlet weak var btNewIncident: UIButton!
    @IBOutlet weak var btSavedImage: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("***** viewWillAppear *****")
        // check if App start
        if Config.savApiCoordinate != nil {
            print("***** startLocationUpdates *****")
            gpsLocation.startLocationUpdates()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print("***** viewDidDisappear *****")
        gpsLocation.stopLocationUpdates()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("***** viewDidLoad *****")
        // Hide Image saved Button
        btSavedImage.isHidden = true

        let qzelaPoints = 1000
        lbQzelaPoints.addTrailing(image: UIImage(named: "ic_trophy") ?? UIImage(), text: String(qzelaPoints) + " ")

        // NetworkListener delegate
        networkListener.networkListenerDelegate = self

        // GPSLocation by protocol delegate
        gpsLocation.delegate = self
        gpsLocation.startLocationUpdates()

        // Initialize Map definitions and Style
        mapInit()

        // Home
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
        // Rua Florida, 1758
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude:-23.6072598, longitude: -46.6951241)

//        let timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [unowned self] (timer) in
//        }
//        RunLoop.current.add(timer, forMode: .common)

    }

    @IBAction func btnClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btMyLocation":
            print("btMyLocation")
            gotoMyLocation()
        case "btViewMap":
            print("btViewMap Clear Markers")
            clearMarkers()
        case "btNewIncident":
            print("btNewIncident")
        case "btSavedImage":
            print("btSavedImage ShowMarkers")
            showMarkers()
        default:
            print(sender.restorationIdentifier ?? "no restoration Identifier defined")
        }
    }

    func mapInit() {
        print("***** MAP INIT - START *****")
        // Load Map style from json file
        do {
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json") {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                print("mapstyle.json Load...")
            } else {
                print("unable to find mapstyle.json")
            }
        } catch {
            print("One or more of the map styles failed to load.\(error)")
        }
        // Get Coordinates
        Config.savCoordinate = gpsLocation.getCoordinate()
        // Enable center point of my location
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(Config.MIN_ZOOM_MAP, maxZoom: Config.MAX_ZOOM_MAP)
        // Set camera bounds for limit map view
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate,
                radiusInMeter: Config.LOCATION_DISTANCE
        )
        mapView.camera = GMSCameraPosition.camera(
                withLatitude: Config.savCoordinate.latitude,
                longitude: Config.savCoordinate.longitude, zoom: Config.ZOOM_INITIAL
        )
        // Google Maps events delegate
        mapView.delegate = self
        print("***** MAP INIT - END *****")
    }

    func gotoMyLocation() {

        print("********* gotoMyLocation - START ********")

        if gpsLocation.isGpsEnable() {
            Config.savCoordinate = gpsLocation.getCoordinate()
            // If not load data from API opn Start.
            if (markerIcon.count == 0) {
                Config.savApiCoordinate = nil
            }
            getIncidentViewport()
        }
        else {
            let alertController = UIAlertController(title: "Location Permission Required", message: "Please enable location permissions in settings.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Settings", style: .default, handler: {(cAlertAction) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
        print("********* gotoMyLocation - END ********")
    }

    func getIncidentViewport() {

        print("******** getIncidentViewport - START **********")

        // check Internet
        if (!networkListener.isNetworkAvailable()) {
            print("******** NO INTERNET CONNECTION *********")
            let alertController = UIAlertController(title: "No Internet", message: "Please, verify your internet connection!", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it!", style: .cancel)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        if (!networkListener.isApiAvailable()) {
            let alertController = UIAlertController(title: "Server off-line", message: "Please, try again later.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Got it!", style: .default)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
            return
        }
        // check if App start
        if Config.savApiCoordinate != nil {
            let distance = gpsLocation.getDistanceInMeters(
                    coordinateOrigin: Config.savCoordinate,
                    coordinateDestiny: Config.savApiCoordinate!)
            print("Distance: \(distance)")
            // check if need load data from API
            if (distance > (Config.PERCENTAGE_DISTANCE_BOUNDS * 1.5)) {
                Config.savApiCoordinate = Config.savCoordinate
            } else {
                return
            }
        } else {
            Config.savApiCoordinate = Config.savCoordinate
        }

        let bounds = gpsLocation.increaseBounds(
                bounds: GMSCoordinateBounds(region: mapView.projection.visibleRegion()),
                percentage: Config.PERCENTAGE_DISTANCE_BOUNDS
        )

        let neCoord: Coordinate = [bounds!.northEast.longitude, bounds!.northEast.latitude]
        let swCoord: Coordinate = [bounds!.southWest.longitude, bounds!.southWest.latitude]

        if (alreadyGetIncidents.isEmpty) {
            clearMap()
        } else {
            var index = 0
            while index < markerIcon.count {
                if (!(bounds!.contains(markerIcon[index].position))) {
                    markerIcon[index].map = nil
                    markerIcon.remove(at: index)
                    markerCircle[index].map = nil
                    markerCircle.remove(at: index)
                    alreadyGetIncidents.remove(at: index)
                    index -= 1
                }
                index += 1
            }
        }

        print("******** GetViewport - START **********")
        Apollo.shared.apollo.fetch(query: GetViewportQuery(
                neCoord: neCoord,
                swCoord: swCoord,
                already: alreadyGetIncidents), cachePolicy: .fetchIgnoringCacheData){ [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let viewport = graphQLResult.data?.getIncidentsByViewport.data.compactMap({ $0 }) {
                    for resultApi in viewport {
                        alreadyGetIncidents.append(resultApi._id);
                        mapAddMarkers(
                                latitude: resultApi.vlLatitude,
                                longitude: resultApi.vlLongitude,
                                segment: resultApi.cdSegment,
                                stIncident: resultApi.stIncident,
                                idIncident: resultApi._id
                        )
                    }
                    print("******** GetViewport - END **********")
                }
            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }

        print("******** getIncidentViewport - END **********")
    }

    func mapAddMarkers(latitude: Double, longitude: Double, segment: Int, stIncident: Int, idIncident: String) {

        var markerStatus: UIImage!

        switch stIncident {
        case 3:
            markerStatus = UIImage(named: "circle_orange")
            break;
        case 4:
            markerStatus = UIImage(named: "circle_green")
            break;
        case 7:
            markerStatus = UIImage(named: "circle_blue")
            break;
        default:
            markerStatus = UIImage(named: "circle_red")
            break;
        }

        let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let distance = self.gpsLocation.getDistanceInMeters(
                coordinateOrigin: Config.savCoordinate,
                coordinateDestiny: coordinate)


        if (segmentIcon[segment] != nil) {
            var marker = GMSMarker()
            marker.position = coordinate
            marker.snippet = idIncident
            marker.icon = segmentIcon[segment]
            marker.setIconSize(scaledToSize: .init(width: 40, height: 65))
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.15)
            markerIcon.append(marker)
            if (distance <= Config.LOCATION_RESTRICT_DISTANCE) {
                marker.map = mapView
            }
            // Incident status Circle Marker
            marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.snippet = idIncident
            marker.icon = markerStatus
            marker.setIconSize(scaledToSize: .init(width: 12, height: 12))
            markerCircle.append(marker)
            if (distance <= Config.LOCATION_RESTRICT_DISTANCE) {
                marker.map = mapView
            }
        } else {
            // Get Segment Marker Icon by FIREBASE on Google Cloud
            let imagesRef = Config.FIREBASE_ICONS_STORAGE.child(Config.MARKERS_ICONS_PATH + String(segment) + ".png")
            // Download in memory with size 160 bytes a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imagesRef.getData(maxSize: Config.MAXBYTES) { markerIcon, error in
                if let error = error {
                    print("ERROR: \(error)")
                } else {
                    // Segment Icon Marker
                    self.segmentIcon[segment] = UIImage(data: markerIcon!)
                    var marker = GMSMarker()
                    marker.position = coordinate
                    marker.snippet = idIncident
                    marker.icon = UIImage(data: markerIcon!)
                    marker.setIconSize(scaledToSize: .init(width: 40, height: 65))
                    marker.groundAnchor = CGPoint(x: 0.5, y: 1.15)
                    self.markerIcon.append(marker)
                    if (distance <= Config.LOCATION_RESTRICT_DISTANCE) {
                        marker.map = self.mapView
                    }
                    // Incident status Circle Marker
                    marker = GMSMarker()
                    marker.position = coordinate
                    marker.snippet = idIncident
                    marker.icon = markerStatus
                    marker.setIconSize(scaledToSize: .init(width: 12, height: 12))
                    self.markerCircle.append(marker)
                    if (distance <= Config.LOCATION_RESTRICT_DISTANCE) {
                        marker.map = self.mapView
                    }
                }
            }
        }
    }

    func showMarkers() {

        for index in 0..<markerIcon.count {
            let distance = gpsLocation.getDistanceInMeters(
                    coordinateOrigin: Config.savCoordinate,
                    coordinateDestiny: markerIcon[index].position)
            if (distance <= Config.LOCATION_RESTRICT_DISTANCE) {
                markerIcon[index].map = mapView
                markerCircle[index].map = mapView
            } else {
                markerIcon[index].map = nil
                markerCircle[index].map = nil
            }
        }
     }

    func clearMarkers() {
        for index in 0..<markerIcon.count {
            self.markerIcon[index].map = nil
            self.markerCircle[index].map = nil
        }
        markerIcon.removeAll()
        markerCircle.removeAll()
        alreadyGetIncidents.removeAll()
        Config.savApiCoordinate = nil
    }

    func clearMap() {
        mapView.clear()
    }
    
    func imageWithImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func gotoNewRootViewController(viewController: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }

    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        present(nextViewController, animated: true)
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: { (context) in

            print("Orientation change")

            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else {
                return
            }

            if windowInterfaceOrientation.isLandscape {
                print("landscape 1")
                // activate landscape changes
            } else {
                print("portrait 1")
                // activate portrait changes
            }
        })
    }

    private var windowInterfaceOrientation: UIInterfaceOrientation? {

        let orientation = view.window?.windowScene?.interfaceOrientation
        return orientation

    }

}

extension UIView {
    func setShadowWithCornerRadius(cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize = .zero, shadowOpacity: Float = 1, shadowRadius: CGFloat) {
        layer.cornerRadius = cornerRadius
        //        layer.masksToBounds = true
        layer.shadowColor = shadowColor.cgColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowRadius = shadowRadius
    }
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
    }, completion: completion)  }

    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.3
    }, completion: completion)
   }

}

extension UILabel {

    func addTrailing(image: UIImage, text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])

        string.append(attachmentString)
        attributedText = string
    }

    func addLeading(image: UIImage, text: String) {
        let attachment = NSTextAttachment()
        attachment.image = image

        let attachmentString = NSAttributedString(attachment: attachment)
        let mutableAttributedString = NSMutableAttributedString()
        mutableAttributedString.append(attachmentString)

        let string = NSMutableAttributedString(string: text, attributes: [:])
        mutableAttributedString.append(string)
        attributedText = mutableAttributedString
    }
}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}

// get Update Position from GPSLocation by Protocol
extension MapTabbarController: GPSLocationDelegate {

    func GPSLocation(didUpdate locations: [CLLocation]) {

        print("******** MapTabbarController - Delegate GPS Location")

        guard let location = locations.first else { return }
        
        if (location.horizontalAccuracy < 0){
            config.showHideNoInternet(view: ivNoGps, show: true)
        }
        else if (location.horizontalAccuracy > 163){
            config.showHideNoInternet(view: ivNoGps, show: true)
        }
        else if (location.horizontalAccuracy > 48){
            config.showHideNoInternet(view: ivNoGps, show: false)
       }
        else{
            config.showHideNoInternet(view: ivNoGps, show: false)
        }

        // TODO: Home location for development test
//        Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
        Config.savCoordinate = location.coordinate
        showMarkers()
        mapView.cameraTargetBounds = nil
        mapView.animate(to: GMSCameraPosition.camera(
                withLatitude: Config.savCoordinate.latitude,
                longitude: Config.savCoordinate.longitude, zoom: Config.savCurrentZoom ))
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate, radiusInMeter: Config.LOCATION_DISTANCE
        )
    }
}

// Events of Network
extension MapTabbarController: NetworkListenerDelegate {
    func didChangeStatus(status: ConnectionType) {

        print("******* MapTabbarController - Network Listener ********")
        switch status {
        case .unknown:
            config.showHideNoInternet(view: ivNoInternet, show: true)
        case .ethernet:
            config.showHideNoInternet(view: ivNoInternet, show: false)
        case .wifi:
            config.showHideNoInternet(view: ivNoInternet, show: false)
        case .cellular:
            config.showHideNoInternet(view: ivNoInternet, show: false)
        }


    }
}

//  Events of Maps
extension MapTabbarController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        print("****** MAP IDLE *****")
        Config.savCurrentZoom =  mapView.camera.zoom
        print("******* Current Zoom: \(Config.savCurrentZoom)")
        getIncidentViewport()
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        print("****** CLICK MARKER *****")
        print(marker.snippet! as String)
        print(marker.title! as String)
        return true
    }

    open func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("****** CLICK ON MAP *******")
    }
}

public typealias Coordinate = [Double]
extension Array: JSONDecodable {
    /// Custom `init` extension so Apollo can decode custom scalar type `CurrentMissionChallenge `
    public init(jsonValue value: JSONValue) throws {
        guard let array = value as? Array else {
            throw JSONDecodingError.couldNotConvert(value: value, to: Array.self)
        }
        self = array
        return
    }
}
