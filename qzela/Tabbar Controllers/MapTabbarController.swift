//
//  MapTabbarController.swift
//  qzela
//
//  Created by Edson Rocha on 19/11/21.
//

import CoreLocation
import GoogleMaps
import UIKit

class MapTabbarController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    var savLatitude: Double = 0.0
    var savLongitude: Double = 0.0

    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var btMyLocation: UIButton!
    @IBOutlet weak var btViewMap: UIButton!
    @IBOutlet weak var btNewIncident: UIButton!
    @IBOutlet weak var btSavedImage: UIButton!
    
    @IBAction func btnClick(_ sender: UIButton) {
        
        switch sender.restorationIdentifier {
        case "btMyLocation":
            print("btMyLocation")
            mapView.animate(to: GMSCameraPosition.camera(withLatitude: savLatitude, longitude: savLongitude, zoom: 18.0))
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        btSavedImage.isHidden = true
        
        locationManager.delegate = self
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
        
        locationManager.startUpdatingLocation()

    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
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
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let location = locations.first else {return}
        
        savLatitude = location.coordinate.latitude
        savLongitude = location.coordinate.longitude
        
        mapView.camera = GMSCameraPosition.camera(withLatitude: savLatitude, longitude: savLongitude, zoom: 18.0)

        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.title = "São Paulo"
        marker.snippet = "Brasil"
        marker.map = mapView

    }
    

    func gotoNewRootViewController(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        self.view.window?.rootViewController = viewController
        self.view.window?.makeKeyAndVisible()
    }
    
    func gotoViewControllerWithBack(viewController: String) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: viewController)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        self.present(nextViewController, animated:true)
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
    
    private var windowInterfaceOrientation: UIInterfaceOrientation? {
        return UIApplication.shared.windows.first?.windowScene?.interfaceOrientation
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
