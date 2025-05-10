import Dependencies
import Foundation

package struct ShakespeareTranslator: Sendable {
  package var translate: @Sendable (String) async throws -> String
}

extension ShakespeareTranslator: DependencyKey {
  package static let liveValue: Self = {
    @Dependency(\.urlSession) var urlSession
    let baseURL = URL(string: "https://api.funtranslations.com/translate/shakespeare.json")!
    return ShakespeareTranslator { text in
      let url = baseURL.appending(queryItems: [URLQueryItem(name: "text", value: text)])
      let (data, _) = try await urlSession.data(from: url)
      struct Response: Decodable {
        struct Contents: Decodable {
          let translated: String
        }
        let contents: Contents
      }
      let response = try JSONDecoder().decode(Response.self, from: data)
      return response.contents.translated
    }
  }()
  
  package static let testValue = ShakespeareTranslator(
    translate: unimplemented("\(Self.self).translate")
  )
}
