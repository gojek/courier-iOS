import CoreTelephony
import Foundation
import Reachability

protocol INetworkTypeProvider {
    var networkType: NetworkType { get }
    var networkWWANType: NetworkType { get }
}

enum NetworkType: Equatable {
    case unknown
    case noConnection
    case wifi
    case wwan2g
    case wwan3g
    case wwan4g
    case unknownTechnology(name: String)

    var trackingId: String {
        switch self {
        case .unknown: return "Unknown"
        case .noConnection: return "No Connection"
        case .wifi: return "Wifi"
        case .wwan2g: return "2G"
        case .wwan3g: return "3G"
        case .wwan4g: return "4G"
        case let .unknownTechnology(name): return "Unknown Technology: \"\(name)\""
        }
    }
}

extension Reachability: INetworkTypeProvider {
    var networkWWANType: NetworkType {
        Self.getWWANNetworkType()
    }

    var networkType: NetworkType {
        switch connection {
        case .unavailable, .none:
            return .noConnection
        case .wifi:
            return .wifi
        case .cellular:
            return Reachability.getWWANNetworkType()
        }
    }

    static func getWWANNetworkType() -> NetworkType {
        guard let currentRadioAccessTechnology = CTTelephonyNetworkInfo().currentRadioAccessTechnology else { return .unknown }
        switch currentRadioAccessTechnology {
        case CTRadioAccessTechnologyGPRS,
             CTRadioAccessTechnologyEdge,
             CTRadioAccessTechnologyCDMA1x:
            return .wwan2g
        case CTRadioAccessTechnologyWCDMA,
             CTRadioAccessTechnologyHSDPA,
             CTRadioAccessTechnologyHSUPA,
             CTRadioAccessTechnologyCDMAEVDORev0,
             CTRadioAccessTechnologyCDMAEVDORevA,
             CTRadioAccessTechnologyCDMAEVDORevB,
             CTRadioAccessTechnologyeHRPD:
            return .wwan3g
        case CTRadioAccessTechnologyLTE:
            return .wwan4g
        default:
            return .unknownTechnology(name: currentRadioAccessTechnology)
        }
    }
}
