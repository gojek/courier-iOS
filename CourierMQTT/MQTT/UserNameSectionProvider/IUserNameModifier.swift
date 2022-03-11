import Foundation

protocol IUserNameModifier {
    func provideUserName(username: String) -> String
}

struct UserNameModifier: IUserNameModifier {

    let userNameSectionProviderList: [IUserNameSectionProvider]

    init(
        countrySectionProvider: IUserNameSectionProvider,
        networkSectionProvider: IUserNameSectionProvider = NetworkSectionProvider(),
        platformSectionProvider: IUserNameSectionProvider = PlatformSectionProvider(),
        appVersionSectionProvider: IUserNameSectionProvider = AppVersionSectionProvider(),
        appStateSectionProvider: IUserNameSectionProvider = AppStateSectionProvider()
    ) {
        self.userNameSectionProviderList = [
            countrySectionProvider,
            networkSectionProvider,
            platformSectionProvider,
            appVersionSectionProvider,
            appStateSectionProvider
        ]
    }

    func provideUserName(username: String) -> String {
        var modifiedUsername = username + ":"
        for sectionProvider in userNameSectionProviderList {
            modifiedUsername = modifiedUsername + sectionProvider.provideSection() + ":"
        }
        return String(modifiedUsername.dropLast())
    }

}
