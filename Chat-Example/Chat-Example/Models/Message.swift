import Foundation

  struct Message: Codable, Identifiable {
    let id: String
    let name: String
    let timestamp: Date
  }
