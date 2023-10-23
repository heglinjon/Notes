//Created for FlaxLabs in 2023
// Using Swift 5.0

import Foundation

struct Note: Identifiable {
    var id: String = UUID().uuidString
    var title: String
    var content: String
}

protocol FirebaseConvertable {
  func toDocument() -> [String: Any]
}

extension Note: FirebaseConvertable {
  init?(from document: [String: Any]) {
    guard let title = document["title"] as? String,
      let content = document["content"] as? String else { return nil }

    self.init(title: title, content: content)
  }

  func toDocument() -> [String : Any] {
    [ "title": self.title,
      "content": "\(self.content)" ]
  }
}

enum NoteError: Error, Equatable {
  case emptyNote
  case unknown(String)
}
