import Dependencies
import Foundation

package struct PokeAPIClient: Sendable {
  var namedEntityData: @Sendable (_ entityType: any NamedAPIEntity.Type, _ name: String) async throws -> Data?
}

extension PokeAPIClient: DependencyKey {
  package static let liveValue: Self = {
    @Dependency(\.urlSession) var urlSession
    let baseURL = URL(string: "https://pokeapi.co/api/v2")!
    return PokeAPIClient { entityType, name in
      let url = baseURL.appending(components: entityType.entityName, name)
      let (data, response) = try await urlSession.data(from: url)
      switch (response as? HTTPURLResponse)?.statusCode {
      case 200:
        return data
      case 404:
        return nil
      default:
        throw PokeAPIClientError.internalError
      }
    }
  }()
  
  package static let testValue = PokeAPIClient(
    namedEntityData: unimplemented("\(Self.self).namedEntityData")
  )
}

extension PokeAPIClient {
  package func entity<Entity: NamedAPIEntity>(for resource: NamedAPIResource<Entity>) async throws -> Entity {
    guard let entity = try await find(Entity.self, named: resource.name) else {
      throw PokeAPIClientError.invalidResource
    }
    
    return entity
  }
  
  package func find<Entity: NamedAPIEntity>(_: Entity.Type, named name: String) async throws -> Entity? {
    guard let data = try await namedEntityData(Entity.self, name) else {
      return nil
    }
    
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return try decoder.decode(Entity.self, from: data)
  }
}

package enum PokeAPIClientError: Error {
  case invalidResource
  case internalError
}
