//Created for FlaxLabs in 2023
// Using Swift 5.0

import XCTest
import Firebase

@testable import FlaxLabs

final class FlaxLabsTests: XCTestCase {

    var viewModel: NotesViewModel!
    
    override func setUpWithError() throws {
        super.setUp()
        viewModel = NotesViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
//        self.clearFirestore()

        super.tearDown()
        
    }

    func test_WhenNoteIsNilAndAddToNoteIsCalled_ThenItReturnsError() {
      // given
      self.viewModel.data = nil
      let exp = self.expectation(description: "Waiting for async operation")

      // when
      self.viewModel.addNote { (result) in
        // then
        switch result {
        case .failure(let error): XCTAssertEqual(error, .emptyNote)
        default: XCTFail()
        }
        exp.fulfill()
      }

      self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_WhenNoteIsNotNilAndAddNoteIsCalled_ThenTheNoteIsAdded() {
      // given
      self.viewModel.data = Note(title: "5th Note", content: "This is for unit test 5")
      let exp = self.expectation(description: "Waiting for async operation")

      // when
      self.viewModel.addNote { (result) in
        // then
        switch result {
        case .success:
          print("Passed")

          // Reading the Notes from the cart to verify the addition of the product
          self.viewModel.fetchNotes { (notes) in

            // There should be exactly 1 product in the cart
            XCTAssertEqual(notes.count, 1)

            // Comparing the Note details
            let note = notes.first!
            XCTAssertEqual(note.title, "5th Note")
            XCTAssertEqual(note.content, "This is for unit test 5")

            exp.fulfill()
          }

        default: XCTFail()
        }
      }

      self.waitForExpectations(timeout: 10, handler: nil)
    }
}

extension XCTestCase {

  func clearFirestore() {
    let semaphore = DispatchSemaphore(value: 0)
    let projectId = FirebaseApp.app()!.options.projectID!
    let url = URL(string: "http://localhost:8080/emulator/v1/projects/\(projectId)/databases/(default)/documents")!
    var request = URLRequest(url: url)
    request.httpMethod = "DELETE"
    let task = URLSession.shared.dataTask(with: request) { _,_,_ in
      print("Firestore cleared")
      semaphore.signal()
    }
    task.resume()
    semaphore.wait()
  }
  
}

