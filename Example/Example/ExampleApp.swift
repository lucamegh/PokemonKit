import SwiftUI

@main
struct ExampleApp: App {
  var body: some Scene {
    WindowGroup {
      NavigationStack {
        PokemonSearchView(model: PokemonSearchModel())
          .navigationTitle("Example")
      }
    }
  }
}
