//
//  Config.swift
//  qzela
//
//  Created by Edson Rocha on 20/11/21.
//
import UIKit
import CoreLocation
import FirebaseStorage

class Config {
    static let MENU_ITEM_DASHBOARD: Int = 0
    static let MENU_ITEM_MAP: Int = 1
    static let MENU_ITEM_PROFILE: Int = 2

    static let ZOOM_INITIAL: Float  = 18.0
    static let ZOOM_LOCATION: Float = 19.0
    static let MIN_ZOOM_LOCATION: Float = 18.0
    static let MIN_ZOOM_MAP: Float = 17.5
    static let MAX_ZOOM_MAP: Float = 20.5
    static let LOCATION_DISTANCE: Double = 50.0 // Max Location distance create incidents near your location
    static let LOCATION_RESTRICT_DISTANCE: Double = 100.0 // Max distance to show incidents on map in near location
    static let LATLNG_REDUCE_BOUNDS_PERCENTAGE: Double = 10 // Reduce bonds percentage of view port
    static let LATLNG_REDUCE_BOUNDS_PERCENTAGE_SAVED_INCIDENT: Double = 30 // Reduce bonds percentage of view port for saved incidents

    static var savCoordinate: CLLocationCoordinate2D!
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
}
