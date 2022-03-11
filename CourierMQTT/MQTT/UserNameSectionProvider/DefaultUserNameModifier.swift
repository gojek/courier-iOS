import Foundation

struct DefaultUserNameModifier: IUserNameModifier {
    func provideUserName(username: String) -> String {
        return username
    }
}
