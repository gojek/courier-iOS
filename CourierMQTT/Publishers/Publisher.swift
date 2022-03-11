import CourierCore
import Foundation

public final class PassthroughSubject<Output, Failure: Error>: AnyPublisher<Output, Failure> {

    private var observable: Observable<Output>

    init(observable: Observable<Output>) {
        self.observable = observable
        super.init()
    }

    public override func filter(
        predicate: @escaping (Output) -> Bool
    ) -> AnyPublisher<Output, Failure> {
        let observable = self.observable
            .observe(on: MainScheduler.asyncInstance)
            .filter(predicate)
        return PassthroughSubject(observable: observable)
    }

    public override func map<Result>(
        transform: @escaping (Output) -> Result
    ) -> AnyPublisher<Result, Failure> {
        let observable = self.observable
            .observe(on: MainScheduler.asyncInstance)
            .map(transform)
        return PassthroughSubject<Result, Failure>(observable: observable)
    }

    public override func sink(
        receiveValue: @escaping (Output) -> Void
    ) -> AnyCancellable {
        let disposable = observable
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { event in
                guard let value = event.element else { return }
                receiveValue(value)
            }
        return DisposeCancellable(disposable)
    }

}

public final class CurrentValueSubject<Output, Failure: Error> {

    private let behaviorSubject: BehaviorSubject<Output>

    public init(_ initialValue: Output) {
        self.behaviorSubject = BehaviorSubject(value: initialValue)
        self.value = initialValue
    }

    public var value: Output {
        didSet {
            let _value = value
            behaviorSubject.onNext(_value)
        }
    }

    public func send(_ value: Output) {
        self.value = value
    }

    public func filter(
        predicate: @escaping (Output) -> Bool
    ) -> AnyPublisher<Output, Failure> {
        let observable = behaviorSubject
            .observe(on: MainScheduler.asyncInstance)
            .filter(predicate)
        return PassthroughSubject(observable: observable)
    }

    public func map<Result>(
        transform: @escaping (Output) -> Result
    ) -> AnyPublisher<Result, Failure> {
        let observable = behaviorSubject
            .observe(on: MainScheduler.asyncInstance)
            .map(transform)
        return PassthroughSubject<Result, Failure>(observable: observable)
    }

    public func sink(
        receiveValue: @escaping (Output) -> Void
    ) -> AnyCancellable {
        let disposable = behaviorSubject
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { event in
                guard let value = event.element else { return }
                receiveValue(value)
            }
        return DisposeCancellable(disposable)
    }

    public func eraseToAnyPublisher() -> AnyPublisher<Output, Failure> {
        let observable = behaviorSubject
            .asObservable()
            .observe(on: MainScheduler.asyncInstance)
        return PassthroughSubject(observable: observable)
    }

    deinit {
        behaviorSubject.onCompleted()
    }

}
