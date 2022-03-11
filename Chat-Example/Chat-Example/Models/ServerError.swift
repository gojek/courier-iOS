import Foundation

  public struct ServerError: Decodable {
    static let Domain = "ServerError"
    static let TitleKey = "ServerError:Title"
    static let CodeKey = "ServerError:Code"

    enum CodingKeys: String, CodingKey {
        case title = "message_title"
        case message
        case code
    }

    var title: String = ""
    var message: String = ""
    var code: String = ""

    public init(title: String, message: String, code: String) {
        self.title = title
        self.message = message
        self.code = code
    }

    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
        message = try values.decodeIfPresent(String.self, forKey: .message) ?? ""
        code = try values.decodeIfPresent(String.self, forKey: .code) ?? ""
    }

    func toNSError() -> NSError {
        return NSError(domain: ServerError.Domain, code: -1, userInfo: [NSLocalizedDescriptionKey: message, ServerError.TitleKey: title, ServerError.CodeKey: code])
    }
  }
