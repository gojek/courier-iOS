import Foundation

@preconcurrency
@propertyWrapper
final class Atomic<T>: @unchecked Sendable {
    private let dispatchQueue: DispatchQueue
    private var _box: Box<T>

    init(_ value: T, dispatchQueueLabel: String = "courier.courier.atomic") {
        self.dispatchQueue = DispatchQueue(label: dispatchQueueLabel, attributes: .concurrent)
        self._box = Box(value)
    }

    var wrappedValue: T {
        get {
            dispatchQueue.sync {
                _box.value
            }
        }
        set {
            let newBox = Box(newValue)
            dispatchQueue.async(flags: .barrier) {
                self._box = newBox
            }
        }
    }

    func mutate(execute task: (inout T) -> Void) {
        dispatchQueue.sync(flags: .barrier) {
            task(&_box.value)
        }
    }

    func mapValue<U>(handler: (T) -> U) -> U {
        dispatchQueue.sync {
            handler(_box.value)
        }
    }
}


private final class Box<T>: @unchecked Sendable {
    var value: T
    init(_ value: T) {
        self.value = value
    }
}
