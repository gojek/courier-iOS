import Foundation
import UIKit

private let appStateObserver = AppStateObserver.shared

public protocol IAppStateObserver: AnyObject {
    var state: UIApplication.State { get }
}

public class AppStateObserver: IAppStateObserver {

    public static let shared = AppStateObserver()
    private let _appState = Atomic<UIApplication.State>(.active)
    public private(set) var state: UIApplication.State {
        set { _appState.mutate { $0 = newValue } }
        get { _appState.value }
    }
    private let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        self.registerObservers()
    }

    func registerObservers() {
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    @objc func appMovedToBackground() {
        state = .background
    }

    @objc func appMovedToForeground() {
        state = .active
    }

    func removeObservers() {
        notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    deinit {
        removeObservers()
    }

}
