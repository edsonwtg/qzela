import Network
import Foundation

protocol NetworkListenerDelegate: AnyObject {
    func didChangeStatus(status: ConnectionType)
}

public enum ConnectionType {
    case wifi
    case ethernet
    case cellular
    case unknown
}

class NetworkListener {

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
    weak var networkListenerDelegate: NetworkListenerDelegate! = nil

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

    func isApiAvailable() -> Bool {
        htmlGetRequest(address: Config.QZELA_API_ADDRESS+"/health")
    }

    func htmlGetRequest(address: String) -> Bool {
        let url = URL(string: address)
        let semaphore = DispatchSemaphore(value: 0)

        var result: Bool = false

        let task = URLSession.shared.dataTask(with: url!) {(data, response, error) in

            if let resp = data {
                if (String(data: resp, encoding: String.Encoding.utf8) == "{\"status\":\"ok\"}") {
                    result = true
                }
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
        return result
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

        DispatchQueue.main.async {
            self.networkListenerDelegate.didChangeStatus(status: networkStatus)
        }

    }

}

