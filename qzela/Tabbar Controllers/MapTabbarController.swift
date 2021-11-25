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
    
    let manager = CLLocationManager()
    var savLatitude: Double = 0.0
    var savLongitude: Double = 0.0

    @IBOutlet weak var btLocationCenter: UIButton!
    @IBOutlet weak var mapView: UIView!
    
    @IBAction func btGotoPreview(_ sender: Any) {
        
        gotoViewControllerWithBack(viewController: "PreviewViewController")

    }
    
    @IBOutlet weak var btGotoPreview: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btGotoPreview.setShadowWithCornerRadius(cornerRadius: btGotoPreview.frame.width * 0.5, shadowColor: .gray, shadowRadius: 5)
        
        manager.delegate = self
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {return}
        
        savLatitude = location.coordinate.latitude
        savLongitude = location.coordinate.longitude
     
        let camera = GMSCameraPosition.camera(withLatitude: savLatitude, longitude: savLongitude, zoom: 18.0)
        let googleMap = GMSMapView.map(withFrame: mapView.frame, camera: camera)
        mapView.addSubview(googleMap)

        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = location.coordinate
        marker.title = "São Paulo"
        marker.snippet = "Brasil"
        marker.map = googleMap
 
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
