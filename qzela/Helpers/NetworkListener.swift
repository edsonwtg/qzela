import Network

protocol NetworkListenerDelegate {
    func didChangeStatus(status: ConnectionType)
}

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetworkListener {
    
    var networkListenerDelegate: NetworkListenerDelegate!
    
    //    static public let shared = NetworkListener()
    var monitor: NWPathMonitor
    var path: NWPath?
    lazy var pathUpdateHandler: (NWPath) -> Void = { path in
        self.path = path
        if path.status == NWPath.Status.satisfied {
            print("Connected")
        } else if path.status == NWPath.Status.unsatisfied {
            print("unsatisfied")
        } else if path.status == NWPath.Status.requiresConnection {
            print("requiresConnection")
        }
    }
    var connType: ConnectionType = .wifi
    
    init() {
        monitor = NWPathMonitor()
//        monitor.pathUpdateHandler = pathUpdateHandler
        monitor.pathUpdateHandler = { path in
            self.checkConnectionTypeForPath(path)
        }
        self.monitor.start(queue: DispatchQueue.global(qos: .background))
    }
    

    func isNetworkAvailable() -> Bool {
        self.checkConnectionTypeForPath(monitor.currentPath)
        if monitor.currentPath.status == NWPath.Status.satisfied {
            return true
        }
        return false
    }
    
    func checkConnectionTypeForPath(_ path: NWPath) {
        
        var networkStatus: ConnectionType = .unknown
        if monitor.currentPath.status == NWPath.Status.satisfied {
            if path.usesInterfaceType(.wifi) {
                networkStatus = .wifi
            } else if path.usesInterfaceType(.wiredEthernet) {
                networkStatus = .ethernet
            } else if path.usesInterfaceType(.cellular) {
                networkStatus = .cellular
            }
        }

        networkListenerDelegate!.didChangeStatus(status: networkStatus)
        
    }
}

