//Created for FlaxLabs in 2023
// Using Swift 5.0

import Foundation
import FirebaseFirestore

protocol NotesDataSource: AnyObject {
    var notes: [Note] { get }
    
    typealias AddToNotesCompletionHandler = (Result<Bool, NoteError>) -> Void
    typealias GetProductsCompletionHandler = ([Note]) -> Void
    
    func fetchNotes(_ completion: @escaping GetProductsCompletionHandler)
    func addNote(_ completion: @escaping AddToNotesCompletionHandler)
    func updateNote(_ note: Note)
    func deleteNote(_ note: Note)
}

class NotesViewModel: ObservableObject, NotesDataSource {
    
    @Published var notes: [Note] = []
    private let db = Firestore.firestore()
    var data : Note?
    
    init() {
        fetchNotes { notes in
            self.notes = notes
        }
    }

    func fetchNotes(_ completion: @escaping GetProductsCompletionHandler) {
        DispatchQueue.global().async {
            self.db.collection("notes").addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {
                    print("Error fetching documents: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                // Handle error
                if error != nil {
                  completion([])
                  return
                }
                
                DispatchQueue.main.async {
                    let notes = documents.compactMap { document in
                        let data = document.data()
                        let id = document.documentID
                        let title = data["title"] as? String ?? ""
                        let content = data["content"] as? String ?? ""
                        return Note(id: id, title: title, content: content)
                    }
                    completion(notes)
                }

            }
        }

    }
    
    func addNote(_ completion: @escaping AddToNotesCompletionHandler) {
        
        guard let note = self.data else {
          completion(.failure(.emptyNote))
          return
        }
        
        db.collection("notes").addDocument(data: note.toDocument()) { (error) in
            
            // Handle the error
            if let error = error {
              completion(.failure(.unknown(error.localizedDescription)))
              return
            }

            // Adding the document was successful
            completion(.success(true))
          }
    }
    
    func updateNote(_ note: Note) {
        print("Updating...")
        let data: [String: Any] = [
            "title": note.title,
            "content": note.content
        ]
        
        db.collection("notes").document(note.id).setData(data) { [weak self] error in
            if let error = error {
                print("Error updating document: \(error.localizedDescription)")
            } else {
                self?.fetchNotes({ notes in
                    self?.notes = notes
                })
            }
        }
    }
    
    func deleteNote(_ note: Note) {
        db.collection("notes").document(note.id).delete { [weak self] error in
            if let error = error {
                print("Error deleting document: \(error.localizedDescription)")
            } else {
                self?.fetchNotes({ notes in
                    self?.notes = notes
                })
            }
        }
    }
    
    func saveNote(title: String, content: String, isEditingNote: Bool, selectedNote: Note?) {
        if isEditingNote {
            guard let note = selectedNote else { return }
            updateNote(Note(id: note.id, title: title, content: content))
        } else {
            addNote { result in
                self.fetchNotes({ nnotes in
                    self.notes = nnotes
                })
            }
        }
    }

}
