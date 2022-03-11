import Foundation
import UIKit

struct AppStateSectionProvider: IUserNameSectionProvider {

    let appStateObserver: IAppStateObserver

    init(appStateObserver: IAppStateObserver = AppStateObserver.shared) {
        self.appStateObserver = appStateObserver
    }

    func provideSection() -> String {
        return getAppState()
    }

    private func getAppState() -> String {
        if appStateObserver.state == .active {
            return "FG"
        } else {
            return "BG"
        }
    }
}
