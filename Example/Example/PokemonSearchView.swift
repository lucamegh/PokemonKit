import Dependencies
import PokemonKit
import SwiftUI

struct PokemonSearchView: View {
  @Bindable var model: PokemonSearchModel
  
  var body: some View {
    List {
      TextField("Search", text: $model.searchText)
        .textInputAutocapitalization(.never)
        .autocorrectionDisabled()
      if let state = model.state {
        switch state {
        case .loading:
          Text("Loading...")
        case .success(let pokemon?):
          PokemonView(pokemon)
        case .success(nil):
          Text("Pokémon Not Found")
        case .failure:
          Text("Oops! Something went wrong...")
        }
      }
    }
    .task(id: model.searchText) {
      await model.search()
    }
  }
}

@MainActor
@Observable
final class PokemonSearchModel {
  var searchText = ""
  
  private(set) var state: State?
  
  @ObservationIgnored
  @Dependency(\.pokemonClient) private var pokemonClient
  
  @ObservationIgnored
  @Dependency(\.continuousClock) private var clock
  
  func search() async {
    do {
      guard !searchText.isEmpty else {
        state = nil
        return
      }
      
      state = .loading
      try await clock.sleep(for: .seconds(1))
      let pokemon = try await pokemonClient.pokemon(searchText)
      state = .success(pokemon)
    } catch {
      guard !(error is CancellationError) else {
        return
      }
      
      state = .failure
    }
  }
}

extension PokemonSearchModel {
  enum State: Hashable {
    case loading
    case success(Pokemon?)
    case failure
  }
}
