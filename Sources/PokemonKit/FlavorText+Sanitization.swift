import PokeAPI

extension FlavorText {
  func sanitized() -> String {
    flavorText
      .replacingOccurrences(of: "\u{000C}", with: "\n")
      .replacingOccurrences(of: "\u{00AD}\n", with: "")
      .replacingOccurrences(of: "\u{00AD}", with: "")
      .replacingOccurrences(of: " -\n", with: " - ")
      .replacingOccurrences(of: "-\n", with: "-")
      .replacingOccurrences(of: "\n", with: " ")
  }
}
