import Dependencies
import Foundation
import PokeAPI
import ShakespeareTranslator

public struct PokemonClient: Sendable {
  public var pokemon: @Sendable (_ named: String) async throws -> Pokemon?
}

extension DependencyValues {
  public var pokemonClient: PokemonClient {
    get { self[PokemonClient.self] }
    set { self[PokemonClient.self] = newValue }
  }
}

extension PokemonClient: DependencyKey {
  public static let liveValue: Self = {
    @Dependency(PokeAPIClient.self) var pokeAPI
    @Dependency(ShakespeareTranslator.self) var translator
    
    return PokemonClient { name in
      guard let pokemonSpecies = try await pokeAPI.find(PokemonSpecies.self, named: name) else {
        return nil
      }
      
      return Pokemon(
        id: Pokemon.ID(pokemonSpecies.name),
        spriteURL: {
          guard let defaultVariety = pokemonSpecies.varieties.first(where: \.isDefault) else {
            throw InternalError()
          }
          
          let pokemon = try await pokeAPI.entity(for: defaultVariety.pokemon)
          return pokemon.sprites.frontDefault
        },
        shakespeareanDescription: {
          guard let englishEntry = pokemonSpecies.flavorTextEntries.first(where: { $0.language == .english }) else {
            throw InternalError()
          }
          
          return try await translator.translate(englishEntry.sanitized())
        }
      )
    }
  }()
  
  public static let testValue = PokemonClient(
    pokemon: unimplemented("\(Self.self).pokemon")
  )
}

private struct InternalError: Error {}
