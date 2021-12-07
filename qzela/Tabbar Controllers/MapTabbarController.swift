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

    var gpsLocation = qzela.GPSLocation()
    var markerIcon: Array<GMSMarker> = []
    var markerCircle: Array<GMSMarker> = []
    var segmentIcon: [Int: UIImage] = [:]


//    let apollo = ApolloClient(url: URL(string: Config.GRAPHQL_ENDPOINT)!)

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbQzelaPoints: UILabel!
    @IBOutlet weak var btMyLocation: UIButton!
    @IBOutlet weak var btViewMap: UIButton!
    @IBOutlet weak var btNewIncident: UIButton!
    @IBOutlet weak var btSavedImage: UIButton!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("***** viewWillAppear *****")
        gpsLocation.startLocationUpdates()
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

        // GPSLocation by protocol delegate
        gpsLocation.delegate = self
        // Home
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
        // Rua Florida, 1758
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude:-23.6072598, longitude: -46.6951241)
        // Get Coordinates
        Config.savCoordinate = gpsLocation.getCoordinate()

        // Google Maps events delegate
        mapView.delegate = self
        // Initialize Map definitions and Style
        mapInit()
        getIncidentViewport()

    }

    @IBAction func btnClick(_ sender: UIButton) {

        switch sender.restorationIdentifier {
        case "btMyLocation":
            print("btMyLocation")
            gotoMyLocation()
        case "btViewMap":
            print("btViewMap")
        case "btNewIncident":
            print("btNewIncident")
        case "btSavedImage":
            print("btSavedImage")
        default:
            print(sender.restorationIdentifier ?? "no restoration Identifier defined")
        }
    }

    func mapInit() {
        print("***** MAP INIT *****")
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
    }

    func gotoMyLocation() {
        Config.savCoordinate = gpsLocation.getCoordinate()
        mapView.cameraTargetBounds = nil
        mapView.camera = GMSCameraPosition.camera(withTarget: Config.savCoordinate, zoom: Config.ZOOM_LOCATION)
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate,
                radiusInMeter: Config.LOCATION_DISTANCE
        )
        getIncidentViewport()
    }

    func getIncidentViewport() {

        if (!markerIcon.isEmpty) {
            markerIcon[0].map = nil
            markerIcon.remove(at: 0)
            markerCircle[0].map = nil
            markerCircle.remove(at: 0)
        }

        let bounds = gpsLocation.reduceBounds(bounds: GMSCoordinateBounds(region: mapView.projection.visibleRegion()), percentage: Config.LATLNG_REDUCE_BOUNDS_PERCENTAGE)
//        let bounds = GMSCoordinateBounds(region: mapView.projection.visibleRegion())
        let neCoord: Coordinate = [ bounds!.northEast.longitude,bounds!.northEast.latitude ]
        let swCoord: Coordinate = [ bounds!.southWest.longitude,bounds!.southWest.latitude ]
//        let neCoord: Coordinate = [ -46.68188021890819, -23.611375575025296 ]
//        let swCoord: Coordinate = [ -46.68377610482275, -23.61438067888537 ]

//        var viewportResult = [GetViewportQuery.Data.GetIncidentsByViewport.Datum]()
        Apollo.shared.apollo.fetch(query: GetViewportQuery(
                neCoord: neCoord,
                swCoord: swCoord,
                already: []), cachePolicy: .fetchIgnoringCacheData) { result in
            switch result {
            case .success(let graphQLResult):
                print("Success! Result: \(graphQLResult)")
                if let viewport = graphQLResult.data?.getIncidentsByViewport.data.compactMap({ $0 }) {
                    for resultApi in viewport {
                        self.mapAddMarkers(
                                latitude: resultApi.vlLatitude,
                                longitude: resultApi.vlLongitude,
                                segment: resultApi.cdSegment,
                                stIncident: resultApi.stIncident,
                                idIncident: resultApi._id
                        )
                    }
//                    viewportResult.append(contentsOf: viewport)
//                    for xxx in viewportResult {
//                        print("Id: \(xxx._id) - Lat: \(xxx.vlLatitude) - Lng: \(xxx.vlLongitude) - Segment: \(xxx.cdSegment), stIncident: \(xxx.stIncident)")
//                    }

                }

            case .failure(let error):
                print("Failure! Error: \(error)")
            }
        }

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

        // Get Segment Marker Icon by FIREBASE on Google Cloud
        let imagesRef = Config.FIREBASE_ICONS_STORAGE.child(Config.MARKERS_ICONS_PATH + String(segment)+".png")
        // Download in memory with size 160 bytes a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        imagesRef.getData(maxSize: Config.MAXBYTES) { markerIcon, error in
            if let error = error {
                print("ERROR: \(error)")
            } else {
                // Segment Icon Marker
                var marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.snippet = idIncident
                marker.icon = UIImage(data: markerIcon!)
                marker.setIconSize(scaledToSize: .init(width: 40, height: 65))
                marker.groundAnchor = CGPoint(x: 0.5, y: 1.15)
                self.markerIcon.append(marker)
                marker.map = self.mapView
                // Incident status Circle Marker
                marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                marker.icon = markerStatus
                marker.setIconSize(scaledToSize: .init(width: 12, height: 12))
                self.markerCircle.append(marker)
                marker.map = self.mapView
            }
        }
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

        guard let location = locations.first else {
            return
        }

        // TODO: Home location for development test
        Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
//        Config.savCoordinate = location.coordinate
        mapView.cameraTargetBounds = nil
        mapView.animate(to: GMSCameraPosition.camera(
                withLatitude: Config.savCoordinate.latitude,
                longitude: Config.savCoordinate.longitude, zoom: 18.0))
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate, radiusInMeter: Config.LOCATION_DISTANCE
        )
    }
}

//  Events of Maps
extension MapTabbarController: GMSMapViewDelegate {

    // Move Map
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {

        print("****** MOVE MAP *****")

    }

    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {

        print("****** CLICK MARKER *****")
        print(marker.snippet! as String)
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

