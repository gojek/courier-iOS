import CourierCore
import Foundation

struct CountrySectionProvider: IUserNameSectionProvider {
    let countryCodeProvider: () -> String
    func provideSection() -> String {
        let countryCode = countryCodeProvider()
        printDebug("COURIER: Country Code - \(countryCode)")
        return countryCode
    }
}
