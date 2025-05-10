import Dependencies
import Foundation
import Tagged

public struct Pokemon: Sendable, Identifiable {
  public let id: Tagged<Self, String>
  public var spriteURL: @Sendable () async throws -> URL = unimplemented("\(Self.self).spriteURL")
  public var shakespeareanDescription: @Sendable () async throws -> String = unimplemented("\(Self.self).shakespeareanDescription")
}

extension Pokemon: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(id)
  }
  
  public static func == (lhs: Self, rhs: Self) -> Bool {
    lhs.id == rhs.id
  }
}
