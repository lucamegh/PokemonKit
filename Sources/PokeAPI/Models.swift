import Foundation

package protocol APIModel: Sendable, Hashable, Codable {}

package protocol APIEntity: APIModel {
  static var entityName: String { get }
}

package protocol NamedAPIEntity: APIEntity {
  var name: String { get }
}

package struct NamedAPIResource<Entity: NamedAPIEntity>: APIModel {
  package let name: String
}

package struct PokemonSpecies: NamedAPIEntity {
  package static let entityName = "pokemon-species"
  package let name: String
  package let flavorTextEntries: [FlavorText]
  package let varieties: [Variety]
}

extension PokemonSpecies {
  package struct Variety: APIModel {
    package let isDefault: Bool
    package let pokemon: NamedAPIResource<Pokemon>
  }
}

package struct Pokemon: NamedAPIEntity {
  package static let entityName = "pokemon"
  package let name: String
  package let sprites: Sprites
}

extension Pokemon {
  package struct Sprites: APIModel {
    package let frontDefault: URL
  }
}

package struct FlavorText: APIModel {
  package let flavorText: String
  package let language: NamedAPIResource<Language>
}

package struct Language: NamedAPIEntity {
  package static let entityName = "language"
  package let name: String
}

extension NamedAPIResource<Language> {
  package static let english = NamedAPIResource(name: "en")
}
