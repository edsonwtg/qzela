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

    let gpsLocation = qzela.GPSLocation()
    let networkListener = NetworkListener()
    var alreadyGetIncidents: Array<String> = []
    var markerIcon: Array<GMSMarker> = []
    var markerCircle: Array<GMSMarker> = []
    var segmentIcon: [Int: UIImage] = [:]

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbQzelaPoints: UILabel!
    @IBOutlet weak var ivNoInternet: UIImageView!
    @IBOutlet weak var ivNoGps: UIImageView!
    @IBOutlet weak var btNewIncident: UIButton!
    @IBOutlet weak var btSavedImage: UIButton!
    @IBOutlet weak var solverLabel: EdgeInsetLabel!
    @IBOutlet weak var btCancel: UIButton!
    
    @IBOutlet weak var aiLoadingData: NVActivityIndicatorView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    @objc func changeStatusInternet(notification: NSNotification) {
        guard let type = notification.userInfo!["type"] else { return }
        // print("******* RECEIVED Notification MapTabbarController - Network Listener \(type) ********")
        if (type as! String == "unknown") {
            config.showHideNoInternet(view: ivNoInternet, show: true)
            tabBarController!.tabBar.items?[Config.MENU_ITEM_DASHBOARD].isEnabled = false
            tabBarController!.tabBar.items?[Config.MENU_ITEM_PROFILE].isEnabled = false
        } else {
            config.showHideNoInternet(view: ivNoInternet, show: false)
            tabBarController!.tabBar.items?[Config.MENU_ITEM_DASHBOARD].isEnabled = true
            tabBarController!.tabBar.items?[Config.MENU_ITEM_PROFILE].isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // print("***** MapTabbarController viewWillAppear *****")
        if (Config.SAVED_INCIDENT) {
            tabBarController?.tabBar.isHidden = true
            clearMarkers();
            gpsLocation.stopLocationUpdates()
            gpsLocation.delegate = nil
            lbQzelaPoints.visibility = .invisible
            btNewIncident.visibility = .invisible
            btSavedImage.visibility = .invisible
            solverLabel.visibility = .visible
            btCancel.visibility = .visible
            mapView.setMinZoom(Config.ZOOM_LOCATION, maxZoom: Config.MAX_ZOOM_MAP)
            mapView.isMyLocationEnabled = false
            gotoMyLocation();
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // print("***** MapTabbarController viewDidAppear *****")
        UIApplication.shared.isIdleTimerDisabled = true
        // NetworkListener Observer
        NotificationCenter.default.addObserver(self, selector: #selector(MapTabbarController.changeStatusInternet), name: NSNotification.Name(rawValue: Config.internetNotificationKey), object: nil)
        // check Internet
        if (!networkListener.isNetworkAvailable()) {
            print("******** NO INTERNET CONNECTION *********")
            config.showHideNoInternet(view: ivNoInternet, show: true)
        } else {
            config.showHideNoInternet(view: ivNoInternet, show: false)
        }
        // check if App start
        if Config.savApiCoordinate != nil {
//            print("***** startLocationUpdates *****")
            gpsLocation.startLocationUpdates()
        }
        if (Config.backIncidentSend) {
            clearMarkers()
            gotoMyLocation()
            Config.backIncidentSend = false
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if (Config.SAVED_INCIDENT) {
            Config.SAVED_INCIDENT = false
            lbQzelaPoints.visibility = .visible
            btNewIncident.visibility = .visible
            btSavedImage.visibility = .visible
            solverLabel.visibility = .invisible
            btCancel.visibility = .invisible
            self.tabBarController?.tabBar.isHidden = false
            mapView.isMyLocationEnabled = true
            gpsLocation.delegate = self
            gpsLocation.startLocationUpdates()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIApplication.shared.isIdleTimerDisabled = false
        // print("***** MapTabbarController viewDidDisappear *****")
        gpsLocation.stopLocationUpdates()
        NotificationCenter.default.removeObserver(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // print("***** viewDidLoad *****")

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)

        aiLoadingData.type = .ballRotateChase
        aiLoadingData.color = .blue

        solverLabel.text = "text_resolver_map".localized()
        solverLabel.borderColorV = UIColor.qzelaDarkBlue
        solverLabel.visibility = .invisible
        btCancel.visibility = .invisible
        ivNoInternet.visibility = .invisible

        // TODO: Pass this functionality to initialize APP function
        // check if simulator or device
//        #if (arch(i386) || arch(x86_64)) && (!os(macOS))
//            Config.isSimulator = true
//        #else
//            Config.isSimulator = false
//        #endif

        // Hide Image saved Button
        btSavedImage.visibility = .invisible

        let qzelaPoints = 1000
        lbQzelaPoints.addTrailing(image: (UIImage(named: "ic_trophy")!.withRenderingMode(.alwaysTemplate)),
                text: String(qzelaPoints) + " ")

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

//        c.type = .ballRotateChase
//        aiLoadingData.color = .blue
    }

    @objc func appMovedToBackground() {
        print("App moved to background!")
    }

    @IBAction func btnClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btMyLocation":
            // print("btMyLocation")
            gotoMyLocation()
        case "btViewMap":
            // print("btViewMap Clear Markers")
            clearMarkers()

        case "btNewIncident":
            // check GPS
            if (gpsLocation.isGpsEnable()) {
                // check camera permission
                if (config.checkCameraPermissions()) {
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
                    showAlert(title: "text_no_camera_permission".localized(),
                            message: "text_camera_never_permission".localized(),
                            type: .error,
                            actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                            style: [.default, .cancel],
                            actions: [actionHandler, nil])
                    return
                }
            }
            else {
                let actionHandler: (UIAlertAction) -> Void = { (action) in
                    //Redirect to Settings app
                    UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
                }
                showAlert(title: "text_no_gps_permission".localized(),
                        message: "text_gps_never_permission".localized(),
                        type: .error,
                        actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                        style: [.default, .cancel],
                        actions: [actionHandler, nil])
                return
            }
            // check Internet
            if (!networkListener.isNetworkAvailable()) {
                // print("******** NO INTERNET CONNECTION *********")
                let actionHandler: (UIAlertAction) -> Void = { (action) in
                    //Redirect to Settings app
                    // print("btNewIncident")
                }
                showAlert(title: "text_no_internet".localized(),
                        message: "text_only_save_occurrence".localized(),
                        type: .attention,
                        actionTitles: ["text_cancel".localized(), "text_continue".localized()],
                        style: [.cancel, .default],
                        actions: [nil, actionHandler])
           }

        case "btSavedImage":
            // print("btSavedImage ShowMarkers")
            showMarkers()
        case "btCancel":
            print("btCancel")
            // Go to Dashboard View Controller
            self.tabBarController!.selectedIndex = Config.MENU_ITEM_DASHBOARD
        default:
            print(sender.restorationIdentifier ?? "no restoration Identifier defined")
        }
    }

    func applicationWillTerminate(_ application: UIApplication) {

        print("applicationWillTerminate")
    }


    func mapInit() {
        // print("***** MAP INIT - START *****")
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
        // Get Coordinates
        Config.savCoordinate = gpsLocation.getCoordinate()
        // Enable center point of my location
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(Config.MIN_ZOOM_MAP, maxZoom: Config.MAX_ZOOM_MAP)
        // Set camera bounds for limit map view
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate,
                radiusInMeter: Config.MAP_MOVE_BOUNDS_DISTANCE
        )
        mapView.camera = GMSCameraPosition.camera(
                withLatitude: Config.savCoordinate.latitude,
                longitude: Config.savCoordinate.longitude, zoom: Config.ZOOM_INITIAL
        )
        // Google Maps events delegate
        mapView.delegate = self
    }

    func gotoMyLocation() {

        // print("********* gotoMyLocation - START ********")
        if gpsLocation.isGpsEnable() {
            if (Config.SAVED_INCIDENT) {
                mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                        centerCoordinate: Config.savCoordinate,
                        radiusInMeter: Config.MAP_MOVE_BOUNDS_DISTANCE_SAVED_INCIDENT
                )
                mapView.camera = GMSCameraPosition.camera(
                        withLatitude: Config.savCoordinate.latitude,
                        longitude: Config.savCoordinate.longitude, zoom: Config.ZOOM_INITIAL
                )

            } else {
                Config.savCoordinate = gpsLocation.getCoordinate()
                Config.savCurrentZoom = Config.ZOOM_INITIAL
                mapView.camera = GMSCameraPosition.camera(
                        withLatitude: Config.savCoordinate.latitude,
                        longitude: Config.savCoordinate.longitude, zoom: Config.ZOOM_INITIAL
                )
            }
            // If not load data from API on Start.
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
                    type: .error,
                    actionTitles: ["text_settings".localized(), "text_cancel".localized()],
                    style: [.default, .cancel],
                    actions: [okSettings, nil],
                    preferredActionIndex: 1)
        }
        // print("********* gotoMyLocation - END ********")
    }

    func getIncidentViewport() {

        // print("******** getIncidentViewport - START **********")

        // check if App start
        if Config.savApiCoordinate != nil && !Config.SAVED_INCIDENT {
            let distance = gpsLocation.getDistanceInMeters(
                    coordinateOrigin: Config.savCoordinate,
                    coordinateDestiny: Config.savApiCoordinate!)
            // print("Distance: \(distance)")
            // check if need load data from API
            if (distance > (Config.PERCENTAGE_DISTANCE_BOUNDS * 1.5)) {
                Config.savApiCoordinate = Config.savCoordinate
//            } else {
//                return
            }
        } else {
            Config.savApiCoordinate = Config.savCoordinate
        }

        // check Internet
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
        // check API
        if (!networkListener.isApiAvailable()) {
            showAlert(title: "text_service_out".localized(),
                    message: "text_service_unavailable".localized(),
                    type: .error,
                    actionTitles: ["text_got_it".localized()],
                    style: [.default],
                    actions: [nil])
            return
        }

        aiLoadingData.startAnimating()

        var bounds = GMSCoordinateBounds()
        if (Config.SAVED_INCIDENT) {
            bounds = gpsLocation.increaseBounds(
                    bounds: GMSCoordinateBounds(region: mapView.projection.visibleRegion()),
                    percentage: Config.PERCENTAGE_DISTANCE_BOUNDS_SAVED_INCIDENT
            )!
        } else {
            bounds = gpsLocation.increaseBounds(
                    bounds: GMSCoordinateBounds(region: mapView.projection.visibleRegion()),
                    percentage: Config.PERCENTAGE_DISTANCE_BOUNDS
            )!
        }
        let neCoord: Coordinate = [bounds.northEast.longitude, bounds.northEast.latitude]
        let swCoord: Coordinate = [bounds.southWest.longitude, bounds.southWest.latitude]

        if (alreadyGetIncidents.isEmpty) {
            clearMap()
        } else {
            var index = 0
            while index < markerIcon.count {
                if (!(bounds.contains(markerIcon[index].position))) {
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

        // print("******** GetViewport - START **********")
        ApolloIOS.shared.apollo.fetch(query: GetViewportQuery(
                neCoord: neCoord,
                swCoord: swCoord,
                already: alreadyGetIncidents), cachePolicy: .fetchIgnoringCacheData){ [unowned self] result in
            switch result {
            case .success(let graphQLResult):
//                print("Success! Result: \(graphQLResult)")
                if let viewport = graphQLResult.data?.getIncidentsByViewport.data.compactMap({ $0 }) {
                    // print("Viewport Count: \(viewport.count)")
                    for resultApi in viewport {
                        if Config.SAVED_INCIDENT && !(resultApi.stIncident == 0 || resultApi.stIncident == 2) {
                            continue
                        }
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
                    // print("******** GetViewport - END **********")
                } else if let errors = graphQLResult.errors {
                    if (errors.first?.message == "1 - You must supply a valid token to access this resource!") {
                        print("******** LOGIN AGAIN **********")
                        let login  = Login()
                        login.getLogin(
                                email: Config.SAV_DC_EMAIL,
                                password: Config.SAV_DC_SENHA,
                                notificationId: Config.SAV_NOTIFICATION_ID
                        ){ [self] result in
                            if !(login.getMessage() == "Login Ok") {
                                showAlert(title: "text_warning".localized(),
                                        message: login.getMessage().localized(),
                                        type: .attention,
                                        actionTitles: ["text_got_it".localized()],
                                        style: [.default],
                                        actions: [nil]
                                )
                            } else {
                                Config.SAV_ACCESS_TOKEN = login.getAccessToken()
                                Config.SAV_CD_USUARIO = login.getUserId()
                                Config.userDefaults.set(Config.SAV_ACCESS_TOKEN, forKey: "accessToken")
                                Config.userDefaults.set(Config.SAV_CD_USUARIO, forKey: "cdUser")
                                getIncidentViewport()
                           }
                        }
                    }
                    print("******** ERROR Loading DATA**********")
                    print(errors)
                    aiLoadingData.stopAnimating()
                }
            case .failure(let error):
                aiLoadingData.stopAnimating()
                print("Failure! Error: \(error)")
            }
        }

        // print("******** getIncidentViewport - END **********")
    }

    func mapAddMarkers(latitude: Double, longitude: Double, segment: Int, stIncident: Int, idIncident: String) {

        var markerStatus: UIImage!

        switch stIncident {
        case 3:
            markerStatus = UIImage(named: "circle_orange")
            break;
        case 1,4:
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

        var restrictDistance: Double = 0
        if (Config.SAVED_INCIDENT) {
            restrictDistance = Config.MARKER_RESTRICT_DISTANCE_SAVED_INCIDENT
        } else {
            restrictDistance = Config.MARKER_RESTRICT_DISTANCE
        }

        if (segmentIcon[segment] != nil) {
            var marker = GMSMarker()
            marker.position = coordinate
            marker.snippet = idIncident
            marker.icon = segmentIcon[segment]
            marker.setIconSize(scaledToSize: .init(width: 40, height: 65))
            marker.groundAnchor = CGPoint(x: 0.5, y: 1.15)
            markerIcon.append(marker)
            if (distance <= restrictDistance) {
                marker.map = mapView
            }
            // Incident status Circle Marker
            marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            marker.snippet = idIncident
            marker.icon = markerStatus
            marker.setIconSize(scaledToSize: .init(width: 12, height: 12))
            markerCircle.append(marker)
            if (distance <= restrictDistance) {
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
                    if (distance <= restrictDistance) {
                        marker.map = self.mapView
                    }
                    // Incident status Circle Marker
                    marker = GMSMarker()
                    marker.position = coordinate
                    marker.snippet = idIncident
                    marker.icon = markerStatus
                    marker.setIconSize(scaledToSize: .init(width: 12, height: 12))
                    self.markerCircle.append(marker)
                    if (distance <= restrictDistance) {
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
            var restrictDistance: Double = 0
            if (Config.SAVED_INCIDENT) {
                restrictDistance = Config.MARKER_RESTRICT_DISTANCE_SAVED_INCIDENT
            } else {
                restrictDistance = Config.MARKER_RESTRICT_DISTANCE
            }
            if (distance <= restrictDistance) {
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

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)

        coordinator.animate(alongsideTransition: { (context) in

            // print("Orientation change")

            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else {
                return
            }

            if windowInterfaceOrientation.isLandscape {
                // print("landscape 1")
                // activate landscape changes
            } else {
                // print("portrait 1")
                // activate portrait changes
            }
        })
    }

    private var windowInterfaceOrientation: UIInterfaceOrientation? {

        let orientation = view.window?.windowScene?.interfaceOrientation
        return orientation

    }
}

// get Update Position from GPSLocation by Protocol
extension MapTabbarController: GPSLocationDelegate {

    func GPSLocation(didUpdateHead heading: CLHeading) {
        let direction = heading.trueHeading
        // print("******** MapTabbarController - Delegate GPS Heading \(direction)")
        mapView.animate(toBearing: direction)

    }

    func GPSLocation(didUpdate locations: [CLLocation]) {

        // print("******** MapTabbarController - Delegate GPS Location")


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
                longitude: Config.savCoordinate.longitude, zoom: Config.savCurrentZoom, bearing: gpsLocation.getHeading(), viewingAngle: 0.0))
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate, radiusInMeter: Config.MAP_MOVE_BOUNDS_DISTANCE
        )
    }
}

//  Events of Maps
extension MapTabbarController: GMSMapViewDelegate {

    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {

        if !(Config.SAVED_INCIDENT) {
            // print("****** MAP IDLE *****")
            Config.savCurrentZoom = mapView.camera.zoom
            // print("******* Current Zoom: \(Config.savCurrentZoom)")
            getIncidentViewport()
        }
    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        // print("****** CLICK MARKER *****")
        let controller = storyboard?.instantiateViewController(withIdentifier: "DialogIncidentViewController") as! DialogIncidentViewController
        controller.modalTransitionStyle = .flipHorizontal
        Config.SAV_CLOSE_MARKER_ID = markerIcon.firstIndex(of: marker)!
        // pass data to view controller
        controller.incidentId = marker.snippet
        present(controller, animated: true)
        // return false - show marker info, return true - not show
        return true
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
