import Foundation

public protocol CourierAvailabilityListener {
    func courierAvailable()
    func courierUnavailable()
    func connectionServiceUnavailable()
    func connectionServiceAvailable()
    func courierConnected()
    func courierDisconnected()
    func courierIdle()
    func courierNotIdle()
    func courierCustomAvailability(event: AnyHashable)
}
