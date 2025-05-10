import Observation
import SwiftUI

public struct PokemonView: View {
  private let model: PokemonModel
  
  public init(_ pokemon: Pokemon) {
    model = PokemonModel(pokemon)
  }
  
  public var body: some View {
    HStack {
      switch model.state {
      case .loading:
        Text("Loading...", bundle: .module)
          .task(model.task)
      case .success(let spriteURL, let description):
        AsyncImage(url: spriteURL) { phase in
          phase.image?
            .resizable()
            .interpolation(.none)
            .scaledToFit()
        }
        .frame(width: 96, height: 96)
        Text(description)
          .font(.subheadline)
      case .failure:
        Text("Oops! Something went wrong...", bundle: .module)
      }
    }
  }
}

@MainActor
@Observable
final class PokemonModel {
  private(set) var state = State.loading
  
  private let pokemon: Pokemon
  
  init(_ pokemon: Pokemon) {
    self.pokemon = pokemon
  }
  
  func task() async {
    do {
      async let spriteURL = pokemon.spriteURL()
      async let description = pokemon.shakespeareanDescription()
      state = try await .success(spriteURL: spriteURL, description: description)
    } catch {
      state = .failure
    }
  }
}

extension PokemonModel {
  enum State: Hashable {
    case loading
    case success(spriteURL: URL, description: String)
    case failure
  }
}
