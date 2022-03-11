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
    private var useAppDidEnterBGAndWillEnterFGNotification: Bool

    init(useAppDidEnterBGAndWillEnterFGNotification: Bool = true,
         notificationCenter: NotificationCenter = .default) {
        self.notificationCenter = notificationCenter
        self.useAppDidEnterBGAndWillEnterFGNotification = useAppDidEnterBGAndWillEnterFGNotification
        self.registerObservers()
    }

    func registerObservers() {
        if useAppDidEnterBGAndWillEnterFGNotification {
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        } else {
            notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(appMovedToForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }

    func update(useAppDidEnterBGAndWillEnterFGNotification: Bool) {
        removeObservers()
        self.useAppDidEnterBGAndWillEnterFGNotification = useAppDidEnterBGAndWillEnterFGNotification
        self.registerObservers()
        DispatchQueue.main.async {
            self.state = UIApplication.shared.applicationState == .background ? .background : .active
        }
    }

    @objc func appMovedToBackground() {
        state = .background
    }

    @objc func appMovedToForeground() {
        state = .active
    }

    func removeObservers() {
        if useAppDidEnterBGAndWillEnterFGNotification {
            notificationCenter.removeObserver(self, name: UIApplication.didEnterBackgroundNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        } else {
            notificationCenter.removeObserver(self, name: UIApplication.willResignActiveNotification, object: nil)
            notificationCenter.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        }
    }

    deinit {
        removeObservers()
    }

}
