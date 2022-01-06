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

class Config {
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
}
