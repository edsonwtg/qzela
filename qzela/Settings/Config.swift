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

class Config {

    static var aiLoadingData: NVActivityIndicatorView!

    static var isSimulator = true

    static let MENU_ITEM_DASHBOARD: Int = 0
    static let MENU_ITEM_MAP: Int = 1
    static let MENU_ITEM_PROFILE: Int = 2

    static let ZOOM_INITIAL: Float = 19.0
    static let ZOOM_LOCATION: Float = 19.0
    static let MIN_ZOOM_LOCATION: Float = 19.0
    static let MIN_ZOOM_MAP: Float = 16.5
    static let MAX_ZOOM_MAP: Float = 20.0
    static let PERCENTAGE_DISTANCE_BOUNDS: Double = 300.0 // Percentage load incidents to markers from center viewport
    static let LOCATION_DISTANCE: Double = 50.0 // Max Location distance create incidents near your location
    static let LOCATION_RESTRICT_DISTANCE: Double = 100.0 // Max distance to show incidents on map in near location
    static let LATLNG_REDUCE_BOUNDS_PERCENTAGE: Double = 15 // Reduce bonds percentage of view port
    static let LATLNG_REDUCE_BOUNDS_PERCENTAGE_SAVED_INCIDENT: Double = 30 // Reduce bonds percentage of view port for saved incidents

    static let PATH_TEMP_FILES: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("QZela")
    static let PATH_SAVED_FILES: String = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("QZela_SAV")

    // JSON struct to save Images
    struct SaveIncidents: Codable {
        var id: Int
        var latitude: Double
        var longitude: Double
        var dateTime: Date
        var savedImages: [SavedImages]

        struct SavedImages: Codable {
            var fileImage: String
        }
    }

    // Variables for pass data from/to view controllers
    static var backSaveIncident = false
    static var deletePhoto = 0
    // *******

    static var saveImages = [SaveIncidents.SavedImages]()
    static var saveIncidents = [SaveIncidents]()
    static var saveQtdIncidents = 0

    static let userDefaults = UserDefaults.standard

    func getUserDefaults() {

        if (Config.userDefaults.integer(forKey: "qtdIncidentSaved") == 0) {
            Config.userDefaults.set(0, forKey: "qtdIncidentSaved")
            Config.userDefaults.set(Config.saveIncidents, forKey: "incidentSaved")
        } else {
            Config.saveQtdIncidents = Config.userDefaults.integer(forKey: "qtdIncidentSaved")
            let jsomData =  Config.userDefaults.object(forKey: "incidentSaved") as! Data
            Config.saveIncidents = try! JSONDecoder().decode([Config.SaveIncidents].self, from: jsomData)
            print(Config.saveIncidents)
        }
    }

    func clearUserDefault() {
        Config.userDefaults.removeObject(forKey: "incidentSaved")
        Config.userDefaults.removeObject(forKey: "qtdIncidentSaved")
    }

    static var savApiCoordinate: CLLocationCoordinate2D?
    static var savCoordinate: CLLocationCoordinate2D!
    static var savCurrentZoom: Float = ZOOM_INITIAL

    // FIREBASE GOOGLE CLOUD
    static let FIREBASE_INCIDENTS_BUCKET_URI: String = "gs://qz-user-data/"
    static let FIREBASE_INCIDENTS_SIGNED_URL: String = "https://storage.cloud.google.com/qz-user-data/"
    static let FIREBASE_INCIDENTS_PUBLIC_URL: String = "https://storage.googleapis.com/qz-user-data/"
    static let FIREBASE_BUCKET_URI: String = "gs://assets.qzela.com.br/"
//    static let INCIDENTS_IMAGES_PATH: String = "images/dev/"
    static let INCIDENTS_IMAGES_PATH: String = "images/stg/"
//    static let INCIDENTS_IMAGES_PATH: String = "images/prd/"
    static let SEGMENTS_ICONS_PATH: String = "images/app/icons/"
    static let MARKERS_ICONS_PATH: String = "images/markers/"
    static let MAXBYTES: Int64 = 1 * 160 * 160

    static let FIREBASE_INCIDENTS_STORAGE = Storage.storage(url: FIREBASE_INCIDENTS_BUCKET_URI).reference()
    static let FIREBASE_ICONS_STORAGE = Storage.storage(url: FIREBASE_BUCKET_URI).reference()

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

    // GRAPHQL ADDRESS
    static let GRAPHQL_ENDPOINT: String = QZELA_API_ADDRESS+"/v2i/graphql"
    static let GRAPHQL_WEBSOCKET: String = QZELA_API_WEBSOCKET+"/graphql"

    static let TYPE_IMAGE_PHOTO: String = "photo"
    static let TYPE_IMAGE_VIDEO: String = "video"

    static let IMAGE_OPEN = "open"
    static let IMAGE_CLOSE = "close"
    static let IMAGE_MAP = "map"

    static let SLIDE_OPEN = "Open"
    static let SLIDE_RESOLVED = "Resolved"
    static let SLIDE_REGISTERED = "Registered"

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
            view.isHidden = false
            UIView.animate(withDuration: 1.5, delay: 0, options: [UIView.AnimationOptions.autoreverse, UIView.AnimationOptions.repeat], animations: {
                view.alpha = 0
            }, completion: nil)
        } else {
            view.isHidden = true
            view.stopAnimating()
        }
    }

    func startLoadingData (view: UIView) {
        let midX = view.center.x
        let midY = view.center.y
        print(midX)
        print(midY)
        let frame = CGRect(x: (midX-25), y: (midY-225), width: 50, height: 50)
        Config.aiLoadingData = NVActivityIndicatorView(frame: frame, type: .ballRotateChase, color: .blue)
        view.addSubview(Config.aiLoadingData)
        Config.aiLoadingData.startAnimating()
    }

    func stopLoadingData() {
        Config.aiLoadingData.stopAnimating()
        Config.aiLoadingData.removeFromSuperview()
    }

    func checkCameraPermissions() -> Bool {
        print(" ****** AVCaptureDevice Status: \(AVCaptureDevice.authorizationStatus(for: .video))")
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
        @unknown default :
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

    func moveImage(fileManager: FileManager, pathFileFrom: String, pathTo: String) {
        do {
            print(pathFileFrom)
            let fileName: String = pathFileFrom.components(separatedBy: "/").last!
            print(fileName)
            let pathFileTo = pathTo+"/"+fileName
            print(pathFileTo)
            try fileManager.moveItem(atPath: pathFileFrom, toPath: pathFileTo)
        } catch {
            print("ERROR MOVE FILE")
        }
    }

    func deleteImage(fileManager: FileManager, pathFileFrom: String) {
        do {
            print(pathFileFrom)
            try fileManager.removeItem(atPath: pathFileFrom)
        } catch {
            print("ERROR MOVE FILE")
        }
    }

func listDirectory(fileManager: FileManager, path: String) {
        do {
            let items = try fileManager.contentsOfDirectory(atPath: path)

            for item in items {
                print("Found \(item)")
            }
        } catch {
            print("Error File Path \(Config.PATH_TEMP_FILES)")
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



}
