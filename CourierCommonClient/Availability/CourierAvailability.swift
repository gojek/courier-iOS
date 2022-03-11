import CourierCore
import CourierMQTT
import Foundation

protocol AvailabilityPublisher: AnyObject {
    var publisher: AnyPublisher<AvailabilityEvent?, Never> { get }
    var policies: [CourierAvailabilityPolicy] { get }
}

public class CourierAvailability: AvailabilityPublisher {
    private let courierAvailabilityObservable: CourierAvailabilityObservable

    public var publisher: AnyPublisher<AvailabilityEvent?, Never> {
        courierAvailabilityObservable
            .currentValueSubject
            .eraseToAnyPublisher()
    }

    public var currentAvailabilityEvent: AvailabilityEvent? {
        courierAvailabilityObservable.currentValueSubject.value
    }

    public var policies: [CourierAvailabilityPolicy] {
        courierAvailabilityObservable.policies
    }

    public init(courierEventManager: CourierEventManager,
                availabilityPoliciesFactory: IAvailabilityPoliciesFactory,
                initialAvailabilityEvent _: AvailabilityEvent? = nil,
                dispatchQueue: DispatchQueue = .main) {
        courierAvailabilityObservable = CourierAvailabilityObservable(
            courierEventManager: courierEventManager,
            availabilityPoliciesFactory: availabilityPoliciesFactory,
            dispatchQueue: dispatchQueue
        )
    }

    deinit {
        courierAvailabilityObservable.destroy()
    }
}
