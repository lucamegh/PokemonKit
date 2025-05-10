# Mobile Engineer Challenge

## PokemonKit

### Dependencies

- [Dependencies](https://github.com/pointfreeco/swift-dependencies)
- [Tagged](https://github.com/pointfreeco/swift-tagged)

### Architecture

PokemonKit package is structured into multiple modules:
- _ShakespeareTranslator_ provides a Fun Translations API wrapper client, enabling the rephrase of English text in the style of Shakespeare.
- _PokeAPI_ is a library for interfacing with the PokeAPI REST service. It leverages Swift protocols and generics to streamline networking operations.
- _PokemonKit_ integrates the PokeAPI module to retrieve Pokémon information, and uses ShakespeareTranslator to translate flavor text in the style of Shakespeare. Prior to translation, the text is sanitized to ensure compatibility with the Fun Translations API. The module also offers a drop-in component to display Pokémon in SwiftUI view hierarchies.

Both ShakespeareTranslator and PokeAPI are intended for use within the scope of the PokemonKit package. Therefore, all entities that need to be accessed by other modules are annotated with the `package` access level.

Although tests primarily cover user-facing features, the entire codebase has been structured with testability in mind.

### Integration

#### Searching Pokémon

You can search for Pokémon by accessing the `PokemonClient` through the [Dependency](https://swiftpackageindex.com/pointfreeco/swift-dependencies/main/documentation/dependencies/dependency) property wrapper.

```swift
import Dependencies
import PokemonKit

@Dependency(\.pokemonClient) var pokemonClient

guard let pokemon = try await pokemonClient.pokemon("pikachu") else {
  // Pokémon name is invalid.
  return
}

// ...
```

`Pokemon` provides two endpoints to retrieve both the Pokémon's sprite and Shakespearean description.

```swift
let spriteURL = try await pokemon.spriteURL()
let description = try await pokemon.shakespeareanDescription()
```

#### Displaying Pokémon

Use `PokemonView` to display Pokémon in SwiftUI views. Simply pass it an instance of `Pokemon`, and the view will take care of loading and displaying the Pokémon's data.

```swift
var body: some View {
  VStack {
    PokemonView(bulbasaur)
    PokemonView(charmander)
    PokemonView(squirtle)
  }
  .navigationTitle("Starters")
}
```

## Example App

### Run

To run the sample app, open either PokemonKit.workspace or Example/Example.xcodeproj and run the Example target.

### Architecture

The app follows the MVVM pattern and consists of a single view for searching Pokémon. To keep things simple, all the source files are organized within a single folder.
