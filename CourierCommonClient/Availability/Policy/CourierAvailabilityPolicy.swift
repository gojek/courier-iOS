import CourierCore
import Foundation

public protocol CourierAvailabilityPolicy: ICourierEventHandler {
    var availabilityHandler: TaskWorkItemHandler { get }

    func setAvailabilityListener(_ listener: CourierAvailabilityListener)
}
