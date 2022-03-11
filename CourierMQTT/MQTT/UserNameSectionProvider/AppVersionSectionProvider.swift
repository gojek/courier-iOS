import Foundation

struct AppVersionSectionProvider: IUserNameSectionProvider {

    let appVersionProvider: IAppVersionProvider
    init(appVersionProvider: IAppVersionProvider = CFBundleAppVersion()) {
        self.appVersionProvider = appVersionProvider
    }

    func provideSection() -> String {
        appVersionProvider.appVersion
    }
}

protocol IAppVersionProvider {
    var appVersion: String { get }
}

struct CFBundleAppVersion: IAppVersionProvider {

    let bundle: Bundle
    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

    var appVersion: String {
        bundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }
}
