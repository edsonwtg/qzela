//
//  Config.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//

import Foundation
import UIKit
import CoreLocation
import FirebaseStorage
import NVActivityIndicatorView
import AVFoundation
import DeviceCheck

class Config {

    static var aiLoadingData: NVActivityIndicatorView!

    static var isSimulator = true

    static let internetNotificationKey = "com.qzela.internetNotificationKey"

    static let ISO_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"

    static let MENU_ITEM_DASHBOARD: Int = 0
    static let MENU_ITEM_MAP: Int = 1
    static let MENU_ITEM_EVENT: Int = 2
    static let MENU_ITEM_PROFILE: Int = 3

    static let ZOOM_INITIAL: Float = 19.0
    static let ZOOM_LOCATION: Float = 19.0
    static let MIN_ZOOM_LOCATION: Float = 19.0
    static let MIN_ZOOM_MAP: Float = 16.5
    static let MAX_ZOOM_MAP: Float = 20.5
    // API data load distance in meters from map view center.
    // PS: (wide distance because the device is in motion. The MARKER_RESTRICT_DISTANCE parameter limits the incidents shown)
    static let PERCENTAGE_DISTANCE_BOUNDS: Double = 300.0
    // API data load distance from map view center for Saved incidentes
    static let PERCENTAGE_DISTANCE_BOUNDS_SAVED_INCIDENT: Double = 20.0

    static let LOCATION_DISTANCE: Double = 20.0 // Max Location distance create incidents near your location
    static let MAP_MOVE_BOUNDS_DISTANCE: Double = 20.0 // Max Map move distance from center location
    static let MAP_MOVE_BOUNDS_DISTANCE_SAVED_INCIDENT: Double = 0.0 // Max Map move distance from center location
    static let MARKER_RESTRICT_DISTANCE: Double = 100.0 // Max distance to show marker incidents on map in near location
    static let MARKER_RESTRICT_DISTANCE_SAVED_INCIDENT: Double = 20.0 // Max distance to show marker incidents on map in near location for Saved Incident

    static let SEGMENT_OCEAN: Array<Int> = [36]
    static let SEGMENT_RIVER: Array<Int> = [36]
    static let SEGMENT_HIGHWAY: Array<Int> = [38]

    static let PATH_TEMP_FILES: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("QZela")
    static let PATH_SAVED_FILES: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("QZela_SAV")

    // JSON struct to save Images
    struct SaveIncidents: Codable {
        var id: Int
        var latitude: Double
        var longitude: Double
        var dateTime: Date
        var imageType: String
        var savedImages: [SavedImages]

        struct SavedImages: Codable {
            var fileImage: String
        }
    }

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

    // Variables for pass data from/to view controllers
    static var backIncidentSend = false
    static var backSaveIncident = false
    static var backIncidentDashboard = false
    static var backSavedDashboard = false
    static var deletePhoto = 0
    // *******

    static var saveImages = [SaveIncidents.SavedImages]()
    static var saveIncidents = [SaveIncidents]()
    static var saveQtdIncidents = 0
    static var saveIncidentPosition = 0
    static var SAVED_INCIDENT = false
    static var CLOSE_INCIDENT = false
    static var SAV_CLOSE_BUCKET: String = ""
    static var SAV_CLOSE_INCIDENT_ID: String = ""
    static var SAV_CLOSE_MARKER_ID: Int = -1
    static var SAV_CLOSE_TP_IMAGE: String = ""
    static var SAV_CLOSE_IMAGE_DIRECTORY: String = ""

    static var SAV_ACCESS_TOKEN: String = ""
    static var SAV_CD_USUARIO: String = ""
    static var SAV_DC_EMAIL: String = ""
    static var SAV_DC_SENHA: String = ""
    static var SAV_OUTER_AUTH: Int = 0
    static var SAV_NOTIFICATION_ID: String = ""
    static let SAV_DEVICE_PLATFORM = "Ios";

    static let CURRENT_LANGUAGE = Locale.current.languageCode!+"_"+Locale.current.regionCode!
    static var SAV_DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString

    func generateToken() {
        let currentDevice = DCDevice.current
        if currentDevice.isSupported {
            currentDevice.generateToken(completionHandler: { (data, error) in
                DispatchQueue.main.async {
                    if (data != nil)  {
                        Config.SAV_DEVICE_ID = data!.base64EncodedString()
                    } else {
                        Config.SAV_DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString
                    }
                }
            })
        } else {
            Config.SAV_DEVICE_ID = UIDevice.current.identifierForVendor!.uuidString
        }
    }


    static let userDefaults = UserDefaults.standard
    func getUserDefaults() {

        if (Config.userDefaults.string(forKey: "accessToken") == nil) {
            Config.userDefaults.set("", forKey: "accessToken")
            Config.userDefaults.set("", forKey: "cdUser")
            Config.userDefaults.set("", forKey: "dcEmail")
            Config.userDefaults.set("", forKey: "dcSenha")
            Config.userDefaults.set("", forKey: "dcSenha")
            Config.userDefaults.set(0, forKey: "outherOAuth")
        }else {
            Config.SAV_ACCESS_TOKEN = Config.userDefaults.string(forKey: "accessToken")!
            Config.SAV_CD_USUARIO = Config.userDefaults.string(forKey: "cdUser")!
            Config.SAV_DC_EMAIL = Config.userDefaults.string(forKey: "dcEmail")!
            Config.SAV_DC_SENHA = Config.userDefaults.string(forKey: "dcSenha")!
            Config.SAV_OUTER_AUTH = Config.userDefaults.integer(forKey: "outherOAuth")
        }
        if (Config.userDefaults.integer(forKey: "qtdIncidentSaved") == 0) {
            Config.userDefaults.set(0, forKey: "qtdIncidentSaved")
            Config.saveIncidents = [SaveIncidents]()
            Config.userDefaults.set(Config.saveIncidents, forKey: "incidentSaved")
        } else {
            Config.saveQtdIncidents = Config.userDefaults.integer(forKey: "qtdIncidentSaved")
            let jsomData = Config.userDefaults.object(forKey: "incidentSaved") as! Data
            Config.saveIncidents = try! JSONDecoder().decode([Config.SaveIncidents].self, from: jsomData)
            // print(Config.saveIncidents)
        }
    }

    func clearUserDefault() {
        Config.userDefaults.removeObject(forKey: "accessToken")
        Config.userDefaults.removeObject(forKey: "cdUser")
        Config.userDefaults.removeObject(forKey: "dcEmail")
        Config.userDefaults.removeObject(forKey: "dcSenha")
        Config.userDefaults.removeObject(forKey: "outherOAuth")
        Config.userDefaults.removeObject(forKey: "incidentSaved")
        Config.userDefaults.removeObject(forKey: "qtdIncidentSaved")
        Config.saveIncidents = [SaveIncidents]()
    }

    static var savApiCoordinate: CLLocationCoordinate2D? // Used to check if the device is in motion
    static var savCoordinate: CLLocationCoordinate2D! // Used for save location of device
    static var savCurrentZoom: Float = ZOOM_INITIAL

    // FIREBASE GOOGLE CLOUD
    static let FIREBASE_INCIDENTS_BUCKET = "qz-user-data"
    static let FIREBASE_INCIDENTS_BUCKET_LEGACY = "westars-qzela.appspot.com"
    static let FIREBASE_INCIDENTS_BUCKET_URI: String = "gs://qz-user-data/"
    static let FIREBASE_INCIDENTS_BUCKET_URI_LEGACY: String = "gs://westars-qzela.appspot.com/"
    static let FIREBASE_INCIDENTS_SIGNED_URL: String = "https://storage.cloud.google.com/qz-user-data/"
    static let FIREBASE_INCIDENTS_PUBLIC_URL: String = "https://storage.googleapis.com/qz-user-data/"
    static let FIREBASE_ICONS_BUCKET_URI: String = "gs://assets.qzela.com.br/"
//    static let INCIDENTS_IMAGES_PATH: String = "images/dev/"
    static let INCIDENTS_IMAGES_PATH: String = "images/stg/"
//    static let INCIDENTS_IMAGES_PATH: String = "images/prd/"
    static let SEGMENTS_ICONS_PATH: String = "images/app/icons/"
    static let MARKERS_ICONS_PATH: String = "images/markers/"
    static let MAXBYTES: Int64 = 1 * 160 * 160

    static let FIREBASE_INCIDENTS_STORAGE = Storage.storage(url: FIREBASE_INCIDENTS_BUCKET_URI).reference()
    static let FIREBASE_ICONS_STORAGE = Storage.storage(url: FIREBASE_ICONS_BUCKET_URI).reference()

    // CONNECTION QZELA GRAPHQL API
    // Develpment
//    static let QZELA_API_ADDRESS: String = "http://192.168.10.22:4000"
//    static let QZELA_API_WEBSOCKET: String = "wss://192.168.10.22:4000"
    // Staging
    static let QZELA_API_ADDRESS: String = "https://stg-corp.qzela.com.br:4000"
    static let QZELA_API_WEBSOCKET: String = "wss://stg-corp.qzela.com.br:4000"
    //Production
//    static let QZELA_API_ADDRESS: String = "https://corp.qzela.com.br:3000"
//    static let QZELA_API_WEBSOCKET: String = "wss://corp.qzela.com.br:4000"

    //Google Geocoding revese URL
    static let GOOGLE_GEOCODING_URL = "https://maps.googleapis.com/maps/api/geocode/json?language=pt-BR&"
    static let GOOGLE_API_KEY = "AIzaSyBFjQHgZpabJaoEECs_8XURO__oa0UaGQY"

    // GRAPHQL ADDRESS
    static let GRAPHQL_ENDPOINT: String = QZELA_API_ADDRESS + "/v2i/graphql"
    static let GRAPHQL_WEBSOCKET: String = QZELA_API_WEBSOCKET + "/graphql"

    static let TYPE_IMAGE_PHOTO: String = "photo"
    static let TYPE_IMAGE_VIDEO: String = "video"

    static let RECORD_VIDEO_TIME = 3
    static var IMAGE_CAPTURED = TYPE_IMAGE_PHOTO

    static let IMAGE_OPEN = "open"
    static let IMAGE_CLOSE = "close"
    static let IMAGE_MAP = "map"

    static let STATUS_OPEN = "Open"
    static let STATUS_RESOLVED = "Resolved"
    static let STATUS_REGISTERED = "Registered"
    static let STATUS_SAVED = "Saved"

    static let INCIDENT_STATUS_OPEN_WITHOUT_CLIENT = 0
    static let INCIDENT_STATUS_CLOSE_WITHOUT_CLIENT = 1
    static let INCIDENT_STATUS_OPEN_WITH_CLIENT = 2
    static let INCIDENT_STATUS_CLOSE_WITH_CLIENT = 4
    static let INCIDENT_STATUS_REGISTERED = 7

    static let ARRAY_INCIDENT_ALL_STATUS_OPEN = [0, 2, 3]
    static let ARRAY_INCIDENT_ALL_STATUS_CLOSE = [1, 4]
    static let ARRAY_INCIDENT_STATUS_REGISTERED = [7]
    static let ARRAY_INCIDENT_ALL_STATUS_CLOSE_REGISTERED = [1, 4, 7]

    static let ARRAY_INCIDENT_ALL_STATUS_WITH_CLIENT = [2, 4]
    static let ARRAY_INCIDENT_ALL_STATUS_WITHOUT_CLIENT = [2, 4]

    static let ARRAY_INCIDENT_ALL_STATUS = [0, 1, 2, 3, 4, 7]

    func showHideNoInternet(view: UIImageView, show: Bool) {
        if (show) {
            view.visibility = .visible
            view.alpha = 20
            view.layoutIfNeeded()
            UIView.animate(withDuration: 1.5, delay: 0, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
                view.alpha = 0
            }, completion: nil)
        } else {
            view.visibility = .invisible
            view.stopAnimating()
        }
    }

    func startLoadingData(view: UIView, color: UIColor) {
        let midX = view.center.x
        let midY = view.center.y
        let frame = CGRect(x: (midX - 25), y: (midY), width: 50, height: 50)
        Config.aiLoadingData = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: color)
        view.addSubview(Config.aiLoadingData)
        Config.aiLoadingData.startAnimating()
    }

    func startLoadingData(view: UIView, color: UIColor, centerPosition: Int) {
        let midX = view.center.x
        let midY = view.center.y
        var frame: CGRect
        if (centerPosition > 0) {
            frame = CGRect(x: (midX - 25), y: (midY + CGFloat(centerPosition)), width: 50, height: 50)
        } else {
            frame = CGRect(x: (midX - 25), y: (midY - CGFloat(centerPosition)), width: 50, height: 50)
        }
        Config.aiLoadingData = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: color)
        view.addSubview(Config.aiLoadingData)
        Config.aiLoadingData.startAnimating()
    }

    func stopLoadingData() {
        Config.aiLoadingData.stopAnimating()
        Config.aiLoadingData.removeFromSuperview()
    }

    func checkCameraPermissions() -> Bool {
        // print(" ****** AVCaptureDevice Status: \(AVCaptureDevice.authorizationStatus(for: .video))")
        var hasPermission = false
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            hasPermission = true
        case .denied:
            hasPermission = false
        case .restricted:
            let semaphore = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    hasPermission = true
                } else {
                    hasPermission = false
                }
                semaphore.signal()
            })
            semaphore.wait()
        case .notDetermined:
            let semaphore = DispatchSemaphore(value: 0)
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted: Bool) in
                if granted {
                    hasPermission = true
                } else {
                    hasPermission = false
                }
                semaphore.signal()
            })
            semaphore.wait()
        @unknown default:
            break
        }
        return hasPermission
    }

    func saveImage(fileManager: FileManager, path: String, fileName: String, image: UIImage) -> String? {

        let url = URL(string: path)
        let imagePath = url!.appendingPathComponent(fileName)
        let urlString: String = imagePath.absoluteString
//        print("FILE AND PATH: \(urlString)")
        let imageData = image.jpegData(compressionQuality: 0.5)
        if (!fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)) {
            print("ERROR FAIL CREATED IMAGE: \(urlString)")
            return nil
        }
        return urlString
    }

    func moveImage(fileManager: FileManager, pathFileFrom: String, pathFileTo: String) {
        do {
            // print(pathFileFrom)
            // print(pathFileTo)
            try fileManager.moveItem(atPath: pathFileFrom, toPath: pathFileTo)
        } catch {
            print("ERROR MOVE FILE")
        }
    }

    func deleteImage(fileManager: FileManager, pathFileFrom: String) {
        do {
            // print(pathFileFrom)
            try fileManager.removeItem(atPath: pathFileFrom)
        } catch {
            print("ERROR DELETE FILE")
        }
    }

    func listDirectory(fileManager: FileManager, path: String) {
        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(path+"/"+item)")
            }
        } catch {
            print("Error File Path \(path)")
        }
    }

    func createDirectory(fileManager: FileManager, path: String) {
        // create document directory
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
    }

    func cleanDirectory(fileManager: FileManager, path: String) {
        if fileManager.fileExists(atPath: path) {
            try! fileManager.removeItem(atPath: path)
        }
        createDirectory(fileManager: fileManager, path: path)
    }

    func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping (_ image: UIImage?) -> Void) {
        DispatchQueue.global().async { //1
            let assetUrl = AVAsset(url: url) //2
            let avAssetImageGenerator = AVAssetImageGenerator(asset: assetUrl) //3
            avAssetImageGenerator.appliesPreferredTrackTransform = true //4
            let thumnailTime = CMTimeMake(value: 2, timescale: 1) //5
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil) //6
                let thumbImage = UIImage(cgImage: cgThumbImage) //7
                DispatchQueue.main.async { //8
                    completion(thumbImage) //9
                }
            } catch {
                print("ERROR GET THUMBNAIL \(error.localizedDescription)") //10
                DispatchQueue.main.async {
                    completion(nil) //11
                }
            }
        }
    }

    func resizeImage(image: UIImage, newHeight: CGFloat) -> UIImage {

        let scale = newHeight / image.size.height
        let newWidth = image.size.width * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage
    }

    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {

        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        image.draw(in: CGRect(x: 0, y: 0, width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return newImage
    }

    func cropToBounds(image: UIImage, width: Double, height: Double) -> UIImage {

        let contextImage: UIImage = UIImage(cgImage: image.cgImage!)
        let contextSize: CGSize = contextImage.size
        var posX: CGFloat = 0.0
        var posY: CGFloat = 0.0
        var cgwidth: CGFloat = CGFloat(width)
        var cgheight: CGFloat = CGFloat(height)

        // See what size is longer and create the center off of that
        if contextSize.width > contextSize.height {
            posX = ((contextSize.width - contextSize.height) / 2)
            posY = 0
            cgwidth = contextSize.height
            cgheight = contextSize.height
        } else {
            posX = 0
            posY = ((contextSize.height - contextSize.width) / 2)
            cgwidth = contextSize.width
            cgheight = contextSize.width
        }

        let rect: CGRect = CGRect(x: posX, y: posY, width: cgwidth, height: cgheight)
        // Create bitmap image from context using the rect
        let imageRef: CGImage = contextImage.cgImage!.cropping(to: rect)!
        // Create a new image based on the imageRef and rotate back to the original orientation
        let image: UIImage = UIImage(cgImage: imageRef, scale: image.scale, orientation: image.imageOrientation)
        return image
    }

    func gotoNewRootViewController(view: UIView, withReuseIdentifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: withReuseIdentifier)
        view.window?.rootViewController = viewController
        view.window?.makeKeyAndVisible()
    }

    func gotoViewControllerWithBack(viewController: UIViewController, withReuseIdentifier: String) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: withReuseIdentifier)
        nextViewController.modalPresentationStyle = .fullScreen
        nextViewController.modalTransitionStyle = .flipHorizontal
        viewController.present(nextViewController, animated: true)
    }


}
