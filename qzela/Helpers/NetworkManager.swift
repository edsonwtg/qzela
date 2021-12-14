//
//  NetworkManager.swift
//  qzela
//
//  Created by Edson Rocha on 09/12/21.
//

import Alamofire

enum NetworkManagerStatus {
    case notReachable
    case unknown
    case ethernetOrWiFi
    case cellular
}

class NetworkManager {
    weak var delegate: NetworkManagerDelegate? = nil
    
    private let reachabilityManager = Alamofire.NetworkReachabilityManager(host: "www.google.com")

    func startNetworkReachabilityObserver() {
        
        // start listening
        reachabilityManager?.startListening(onUpdatePerforming: { [weak self] status in
            
            var networkStatus: NetworkManagerStatus = .unknown
            switch status {
                case .notReachable:
                    networkStatus = .notReachable
                case .unknown :
                    networkStatus = .unknown
                case .reachable(.ethernetOrWiFi):
                    networkStatus = .ethernetOrWiFi
                case .reachable(.cellular):
                    networkStatus = .cellular
            }
            self?.delegate?.networkReachabilityStatus(status: networkStatus)
            
        })
        


    }
    
    func stopNetworkReachabilityObserver() {
        reachabilityManager?.stopListening()
    }

    func isInternetAvailable() -> Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
}

protocol NetworkManagerDelegate: AnyObject {
    func networkReachabilityStatus(status: NetworkManagerStatus)
}
