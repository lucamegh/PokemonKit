import Foundation
import Testing
@testable import PokemonKit

@MainActor
struct PokemonModelTests {
  @Test func loading() {
    let model = PokemonModel(Pokemon(id: "foo"))
    #expect(model.state == .loading)
  }
  
  @Test func success() async {
    let pokemon = Pokemon(
      id: "foo",
      spriteURL: { URL(string: "about:blank")! },
      shakespeareanDescription: { "foo" }
    )
    let model = PokemonModel(pokemon)
    await model.task()
    #expect(model.state == .success(spriteURL: URL(string: "about:blank")!, description: "foo"))
  }
  
  @Test func failure_spriteURL() async {
    let pokemon = Pokemon(
      id: "foo",
      spriteURL: { throw SomeError() },
      shakespeareanDescription: { "foo" }
    )
    let model = PokemonModel(pokemon)
    await model.task()
    #expect(model.state == .failure)
  }
  
  @Test func failure_description() async {
    let pokemon = Pokemon(
      id: "foo",
      spriteURL: { URL(string: "about:blank")! },
      shakespeareanDescription: { throw SomeError() }
    )
    let model = PokemonModel(pokemon)
    await model.task()
    #expect(model.state == .failure)
  }
}

private struct SomeError: Error {}
