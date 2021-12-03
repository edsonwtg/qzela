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

class MapTabbarController: UIViewController {
    
    var gpsLocation = qzela.GPSLocation()
    var markerIcon: Array<GMSMarker> = []
    var markerCircle: Array<GMSMarker> = []
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var lbQzelaPoints: UILabel!
    @IBOutlet weak var btMyLocation: UIButton!
    @IBOutlet weak var btViewMap: UIButton!
    @IBOutlet weak var btNewIncident: UIButton!
    @IBOutlet weak var btSavedImage: UIButton!
    
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

        let qzelaPoints = 1000
        lbQzelaPoints.addTrailing(image: UIImage(named: "ic_trophy") ?? UIImage(), text: String(qzelaPoints)+" ")

        // Hide Image saved Button
        btSavedImage.isHidden = true
        
        // Google Maps events delegate
        mapView.delegate = self
        
        // GPSLocation by protocol delegate
        gpsLocation.delegate = self
        
        // Home
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude: -23.612992, longitude: -46.682762)
        // Rua Florida, 1758
        //         Config.savCoordinate = CLLocationCoordinate2D(latitude:-23.6072598, longitude: -46.6951241)
        // Get Coordinates
        Config.savCoordinate = gpsLocation.getCoordinate()

        // Enable center point of my location
        mapView.isMyLocationEnabled = true
        mapView.setMinZoom(Config.MIN_ZOOM_MAP, maxZoom: Config.MAX_ZOOM_MAP)
        // Load Map style from json file
        loadMapStyle()
        // Set camera bounds for limit map view
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate,
                radiusInMeter: Config.LOCATION_DISTANCE
        )
        mapView.camera = GMSCameraPosition.camera(
            withLatitude: Config.savCoordinate.latitude,
            longitude: Config.savCoordinate.longitude, zoom: Config.ZOOM_INITIAL
        )
        
        let marker = GMSMarker(position: Config.savCoordinate)
        marker.title = "São Paulo"
        marker.snippet = "Brasil"
        marker.icon = UIImage(named: "0")
        marker.setIconSize(scaledToSize: .init(width: 40, height: 65))
        marker.groundAnchor = CGPoint(x: 0.5,y: 1.15)
        marker.map = mapView
        
        let markerStatus = GMSMarker(position: Config.savCoordinate)
        markerStatus.icon = UIImage(named: "circle_blue")
        markerStatus.setIconSize(scaledToSize: .init(width: 12, height: 12))
        markerStatus.map = mapView
    }
    
    func gotoMyLocation() {
        Config.savCoordinate = gpsLocation.getCoordinate()
        mapView.cameraTargetBounds = nil
        mapView.camera = GMSCameraPosition.camera(withTarget: Config.savCoordinate, zoom: Config.ZOOM_LOCATION)
        mapView.cameraTargetBounds = gpsLocation.getLatLngBounds(
                centerCoordinate: Config.savCoordinate,
                radiusInMeter: Config.LOCATION_DISTANCE
        )
    }

    func imageWithImage(image:UIImage, scaledToSize newSize:CGSize) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }
    
    func gotoNewRootViewController(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }
    
    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        present(nextViewController, animated:true)
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransition(to: newCollection, with: coordinator)
        
        coordinator.animate(alongsideTransition: { (context) in
            
            print("Orientation change")
            
            guard let windowInterfaceOrientation = self.windowInterfaceOrientation else { return }
            
            if windowInterfaceOrientation.isLandscape {
                print("landscape 1")
                // activate landscape changes
            } else {
                print("portrait 1")
                // activate portrait changes
            }
        })
    }

    func loadMapStyle() {
        do{
            if let styleURL = Bundle.main.url(forResource: "mapstyle", withExtension: "json")
            {
                mapView.mapStyle = try GMSMapStyle(contentsOfFileURL: styleURL)
                print("mapstyle.json Load...")
            }else{
                print("unable to find mapstyle.json")
            }
        }catch{
            print("One or more of the map styles failed to load.\(error)")
        }
    }
    
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
    }
    
}

extension UIView {
    func setShadowWithCornerRadius( cornerRadius: CGFloat, shadowColor: UIColor, shadowOffset: CGSize = .zero, shadowOpacity: Float = 1, shadowRadius: CGFloat) {
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
    
    func addTrailing(image: UIImage, text:String) {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        let attachmentString = NSAttributedString(attachment: attachment)
        let string = NSMutableAttributedString(string: text, attributes: [:])
        
        string.append(attachmentString)
        attributedText = string
    }
    
    func addLeading(image: UIImage, text:String) {
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
        
        guard let location = locations.first else { return }
        mapView.animate(to: GMSCameraPosition.camera(
            withLatitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude, zoom: 18.0))
        //        for currentLocation in locations {
        //            print("Update Location:\(currentLocation)")
        //        }
    }
}

extension MapTabbarController: GMSMapViewDelegate {
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        
        print("****** MAP MOVE *****")
    }
    
}
