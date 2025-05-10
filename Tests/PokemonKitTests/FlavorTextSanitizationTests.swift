import Testing
@testable import PokeAPI
@testable import PokemonKit

struct FlavorTextSanitizationTests {
  @Test(arguments: [
    (flavorText: " -\n-\n­­\n\n\u{0C}", sanitized: " - -  "),
    (flavorText: "-\n\n\u{0C} -\n­\n­", sanitized: "-   - "),
    (flavorText: "\u{0C} -\n­\n­\n-\n", sanitized: "  - -"),
    (flavorText: "­ -\n-\n\n­\n\u{0C}", sanitized: " - -  "),
    (flavorText: " -\n\n-\n­\n\u{0C}­", sanitized: " -  - "),
    (flavorText: "\n­\n -\n-\n\u{0C}­", sanitized: "  - - "),
    (flavorText: " -\n-\n­­\n\u{0C}\n", sanitized: " - -  "),
    (flavorText: " -\n­\n\n-\n\u{0C}­", sanitized: " -  - ")
  ])
  func sanitizedFlavorText(_ flavorText: String, sanitized: String) {
    let entry = FlavorText(flavorText: flavorText, language: .english)
    #expect(entry.sanitized() == sanitized)
  }
}
