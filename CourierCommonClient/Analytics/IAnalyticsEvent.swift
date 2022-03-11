import Foundation

protocol IAnalyticsEvent: AnyObject {
    var name: String { get }
    var properties: [String: String] { get set }
}
