//
//  MapTabbarController.swift
//  qzela
//
//  Created by Edson Rocha on 19/11/21.
//

import GoogleMaps
import UIKit

class MapTabbarController: UIViewController {
    
    var savLatitude: Double = -23.612992
    var savLongitude: Double = -46.682762
    var savCoordinate = CLLocationCoordinate2D()
    var tracking = GPSTrackingManager()
    var markerIcon: Array<GMSMarker> = []
    var markerCircle: Array<GMSMarker> = []
    
    // Rua Florida, 1758
    // var savLatitude: Double = -23.6072598
    // var savLongitude: Double = -46.6951241
    
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
            savLatitude = tracking.getLat()
            savLongitude = tracking.getLon()
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

        tracking.startTracking()

         //        btSavedImage.isHidden = true
        
//        savCoordinate = CLLocationCoordinate2D(latitude: savLatitude, longitude: savLongitude)
//
//
//        savLatitude = GpsLocation.shared.getLat()
//        savLongitude = GpsLocation.shared.getLon()
//        savCoordinate =  GpsLocation.shared.getCoordinate()!
//
//        mapView.isMyLocationEnabled = true
//        mapView.camera = GMSCameraPosition.camera(withLatitude: savLatitude, longitude: savLongitude, zoom: 18.0)
//
//        let marker = GMSMarker(position: savCoordinate)
//        marker.title = "São Paulo"
//        marker.snippet = "Brasil"
//        marker.icon = UIImage(named: "0")
//        marker.setIconSize(scaledToSize: .init(width: 40, height: 65))
//        marker.groundAnchor = CGPoint(x: 0.5,y: 1.15)
//        marker.map = mapView
//
//        let markerStatus = GMSMarker(position: savCoordinate)
//        markerStatus.icon = UIImage(named: "circle_blue")
//        markerStatus.setIconSize(scaledToSize: .init(width: 12, height: 12))
//        markerStatus.map = mapView
//
//        let qzelaPoints = 1000
//        lbQzelaPoints.addTrailing(image: UIImage(named: "ic_trophy") ?? UIImage(), text: String(qzelaPoints)+" ")
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
