import CourierCore
import Foundation

final class DisposeCancellable: AnyCancellable {
    private var _disposable: Disposable?

    init(_ disposable: Disposable) {
        _disposable = disposable
        super.init()
    }

    public override func cancel() {
        _disposable?.dispose()
        _disposable = nil
    }

    deinit {
        _disposable?.dispose()
        _disposable = nil
    }
}
