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
import NVActivityIndicatorView


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

    @IBOutlet weak var aiLoadingData: NVActivityIndicatorView!
    override var preferredStatusBarStyle: UIStatusBarStyle {
        aiLoadingData.type = .ballRotateChase
        aiLoadingData.color = .blue

        return .lightContent
    }

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

//        aiLoadingData.type = .ballRotateChase
//        aiLoadingData.color = .blue
        
        
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
            // check GPS
            if (gpsLocation.isGpsEnable()) {
                Config.savCoordinate = gpsLocation.getCoordinate()
                // Go to Photo View Controller
                let controller = storyboard?.instantiateViewController(withIdentifier: "PhotoViewController") as! PhotoViewController
                controller.modalPresentationStyle = .fullScreen
                controller.modalTransitionStyle = .crossDissolve
                present(controller, animated: true)
            }
            else {
                let actionHandler: (UIAlertAction) -> Void = { (action) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                showAlert(title: "text_gps_permission".localized(),
                        message: "text_gps_never_permission".localized(),
                        actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                        style: [.default, .cancel],
                        actions: [actionHandler, nil])
                return
            }
            // check Internet
            if (!networkListener.isNetworkAvailable()) {
                print("******** NO INTERNET CONNECTION *********")
                let actionHandler: (UIAlertAction) -> Void = { (action) in
                    //Redirect to Settings app
                    print("btNewIncident")
                }
                showAlert(title: "text_no_internet".localized(),
                        message: "text_only_save_occurrence".localized(),
                        actionTitles: ["text_cancel".localized(), "text_continue".localized()],
                        style: [.cancel, .default],
                        actions: [nil, actionHandler])
           }

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
            let okSettings: (UIAlertAction) -> Void = { (action) in
                //Redirect to Settings app
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            showAlert(title: "text_no_gps_permission".localized(),
                    message: "text_gps_permission".localized(),
                    actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                    style: [.default, .cancel],
                    actions: [okSettings, nil],
                    preferredActionIndex: 1)
        }
        print("********* gotoMyLocation - END ********")
    }

    func getIncidentViewport() {

        print("******** getIncidentViewport - START **********")

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

        // check Internet
        if (!networkListener.isNetworkAvailable()) {
            print("******** NO INTERNET CONNECTION *********")
            showAlert(title: "text_no_internet".localized(),
                    message: "text_internet_off".localized(),
                    actionTitles: ["text_got_it".localized()],
                    style: [.default],
                    actions: [nil])
            return
        }
        // check API
        if (!networkListener.isApiAvailable()) {
            showAlert(title: "text_service_out".localized(),
                    message: "text_service_unavailable".localized(),
                    actionTitles: ["text_got_it".localized()],
                    style: [.default],
                    actions: [nil])
            return
        }

        aiLoadingData.startAnimating()

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
                    aiLoadingData.stopAnimating()
                    print("******** GetViewport - END **********")
                } else {
                    aiLoadingData.stopAnimating()
                    print("******** Stop Loading **********")
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
        let distance = gpsLocation.getDistanceInMeters(
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
            markerIcon[index].map = nil
            markerCircle[index].map = nil
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
//        nextViewController.modalPresentationStyle = .fullScreen
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

extension UIViewController {

/// Show alert view
/// - Parameter title: title of alert
/// - Parameter message: message of alert
/// - Parameter actionTitles: List of action button titles(ex : "OK","Cancel" etc)
/// - Parameter style: Style of the buttons
/// - Parameter actions: actions repective to each actionTitles
/// - Parameter preferredActionIndex: Index of the button that needs to be shown in bold. If nil is passed, default button will be cancel.

/**
 Example usage:-
 Just make sure actionTitles and actions array the same count.

 /********** 1. Pass nil if you don't need any action handler closure. **************/
 self.showAlert(title: "Title", message: "message", actionTitles: ["OK"], style: [.deafult], actions: [nil])

 /*********** 2. Alert view with one action **************/

 ///     let okActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of Ok here
 }
 self.showAlert(title: "Title", message: "message", actionTitles: ["OK", "CANCEL"], style: [.default, .cancel], actions: [okayActionHandler, nil])

 /********** 3.Alert view with two actions **************/

 let okActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of ok here
 }

 let cancelActionHandler: ((UIAlertAction) -> Void) = {(action) in
 //Perform action of cancel here
 }

 self.showAlert(title: "Title", message: "message", actionTitles: ["OK", "CANCEL"], style: [.default, .cancel], actions: [okActionHandler,cancelActionHandler], preferredActionIndex: 1)
 */

    public func showAlert(title: String?,
                          message: String?,
                          actionTitles: [String?],
                          style: [UIAlertAction.Style],
                          actions: [((UIAlertAction) -> Void)?],
                          preferredActionIndex: Int? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        for (index, title) in actionTitles.enumerated() {
            let action = UIAlertAction(title: title, style: style[index], handler: actions[index])
            alert.addAction(action)
        }
        if let preferredActionIndex = preferredActionIndex { alert.preferredAction = alert.actions[preferredActionIndex] }
        present(alert, animated: true, completion: nil)
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

        let controller = storyboard?.instantiateViewController(withIdentifier: "PopUpMarkerViewController") as! PopUpMarkerViewController
        controller.modalTransitionStyle = .flipHorizontal
        // pass data to view controller
        controller.incidentId = marker.snippet
        present(controller, animated: true)

        // return false - show marker info, return true - not show
        return true
    }

    open func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("****** CLICK ON MAP *******")
    }
}
