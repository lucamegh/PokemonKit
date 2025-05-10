import Dependencies
import DependenciesTestSupport
import Testing
@testable import Example
@testable import PokemonKit

@MainActor
@Suite(.dependency(\.continuousClock, ImmediateClock()))
struct PokemonSearchModelTests {
  @Test func emptySearchText() async {
    let model = PokemonSearchModel()
    model.searchText = ""
    await model.search()
    #expect(model.state == nil)
  }
  
  @Test func success_pokemonNotFound() async {
    await withDependencies {
      $0.pokemonClient.pokemon = { _ in nil }
    } operation: {
      let model = PokemonSearchModel()
      model.searchText = "missingno"
      await model.search()
      #expect(model.state == .success(nil))
    }
  }
  
  @Test func success_pokemonFound() async {
    await withDependencies {
      $0.pokemonClient.pokemon = { name in
        Pokemon(id: Pokemon.ID(name))
      }
    } operation: {
      let model = PokemonSearchModel()
      model.searchText = "pikachu"
      await model.search()
      #expect(model.state == .success(Pokemon(id: "pikachu")))
    }
  }
  
  @Test func failure() async {
    await withDependencies {
      $0.pokemonClient.pokemon = { _ in
        struct SomeError: Error {}
        throw SomeError()
      }
    } operation: {
      let model = PokemonSearchModel()
      model.searchText = "pikachu"
      await model.search()
      #expect(model.state == .failure)
    }
  }
}
