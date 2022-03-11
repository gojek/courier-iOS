@testable import CourierCore
@testable import CourierMQTT

class MockUserNameSectionProvider: IUserNameSectionProvider {

    var invokedProvideSection = false
    var invokedProvideSectionCount = 0
    var stubbedProvideSectionResult: String! = ""

    func provideSection() -> String {
        invokedProvideSection = true
        invokedProvideSectionCount += 1
        return stubbedProvideSectionResult
    }
}
