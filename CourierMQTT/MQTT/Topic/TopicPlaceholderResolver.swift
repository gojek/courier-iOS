import CourierCore
import Foundation

enum TopicPlaceholderError: Error, Equatable, CustomStringConvertible {
    case invalidPartIndex(placeholder: String, delimiter: String, partIndex: Int, partsCount: Int)
    case unsupportedPlaceholder(String)

    var description: String {
        switch self {
        case let .invalidPartIndex(placeholder, delimiter, partIndex, partsCount):
            return "Invalid part index \(partIndex) for placeholder '\(placeholder)' split by '\(delimiter)': only \(partsCount) part(s) available"
        case let .unsupportedPlaceholder(placeholder):
            return "Unsupported placeholder: \(placeholder)"
        }
    }
}

struct TopicPlaceholderResolver {

    private static let placeholderPrefix = "%"
    private static let usernamePlaceholder = "%u"
    private static let clientIdPlaceholder = "%c"

    // Matches split placeholders like (%c,:,2) -> captures the placeholder (%c/%u), the
    // delimiter (any run of characters other than ',' and ')') and the 0-based part index.
    private let splitPlaceholderRegex = try! NSRegularExpression(pattern: #"\((%[a-zA-Z]),([^,)]+),(\d+)\)"#)

    func resolve(topic: String, connectOptions: ConnectOptions) throws -> String {
        guard topic.contains(Self.placeholderPrefix) else {
            return topic
        }

        var resolvedTopic = try resolveSplitPlaceholders(in: topic, connectOptions: connectOptions)
        resolvedTopic = resolvedTopic
            .replacingOccurrences(of: Self.usernamePlaceholder, with: connectOptions.username)
            .replacingOccurrences(of: Self.clientIdPlaceholder, with: connectOptions.clientId)
        printDebug("MQTT - COURIER: \(topic) is resolved to \(resolvedTopic), username: \(connectOptions.username), clientId: \(connectOptions.clientId)")
        return resolvedTopic
    }

    private func resolveSplitPlaceholders(in topic: String, connectOptions: ConnectOptions) throws -> String {
        let matches = splitPlaceholderRegex.matches(in: topic, range: NSRange(topic.startIndex..., in: topic))
        guard !matches.isEmpty else {
            return topic
        }

        var resolvedTopic = ""
        var lastIndex = topic.startIndex
        for match in matches {
            guard let matchRange = Range(match.range, in: topic),
                  let placeholderRange = Range(match.range(at: 1), in: topic),
                  let delimiterRange = Range(match.range(at: 2), in: topic),
                  let partIndexRange = Range(match.range(at: 3), in: topic),
                  let partIndex = Int(topic[partIndexRange]) else {
                continue
            }
            let placeholder = String(topic[placeholderRange])
            let delimiter = String(topic[delimiterRange])
            let parts = try placeholderValue(placeholder, connectOptions: connectOptions)
                .components(separatedBy: delimiter)
            guard parts.indices.contains(partIndex) else {
                throw TopicPlaceholderError.invalidPartIndex(
                    placeholder: placeholder,
                    delimiter: delimiter,
                    partIndex: partIndex,
                    partsCount: parts.count
                )
            }
            resolvedTopic += topic[lastIndex..<matchRange.lowerBound]
            resolvedTopic += parts[partIndex]
            lastIndex = matchRange.upperBound
        }
        resolvedTopic += topic[lastIndex...]
        return resolvedTopic
    }

    private func placeholderValue(_ placeholder: String, connectOptions: ConnectOptions) throws -> String {
        switch placeholder {
        case Self.usernamePlaceholder:
            return connectOptions.username
        case Self.clientIdPlaceholder:
            return connectOptions.clientId
        default:
            throw TopicPlaceholderError.unsupportedPlaceholder(placeholder)
        }
    }
}
