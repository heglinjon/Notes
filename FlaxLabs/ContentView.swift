//Created for FlaxLabs in 2023
// Using Swift 5.0

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel : NotesViewModel = NotesViewModel()

    @State private var newNoteTitle = ""
    @State private var newNoteContent = ""
    @State private var isShowingNoteSheet = false
    @State private var isEditingNote = false
    @State private var selectedNote: Note?
    @State var sheetAction: SheetAction = SheetAction.nothing
    
    
    
    var body: some View {

        NavigationView {
            List {
                ForEach(viewModel.notes) { note in
                    Button(action: {
                        selectedNote = note
                        newNoteTitle = note.title
                        newNoteContent = note.content
                        isEditingNote = true
                        isShowingNoteSheet = true
                    }) {
                        Text(note.title)
                    }
                    .swipeActions(edge: .leading, allowsFullSwipe: false) {
                        Button(action: {
                            viewModel.deleteNote(note)
                        }) {
                            Label("Delete", systemImage: "trash")
                        }
                        .tint(.red)
                    }
                }
            }
            .navigationTitle("Notes")
            .navigationBarItems(trailing:
                Button(action: {
                    isShowingNoteSheet = true
                    isEditingNote = false
                    newNoteTitle = ""
                    newNoteContent = ""
                }) {
                    Image(systemName: "plus")
                        .font(.title)
                }
            )
        }
        .sheet(isPresented: $isShowingNoteSheet, onDismiss: {
            if sheetAction == .nothing {
                saveNote()
            }
        },content:{
            NoteSheet(title: $newNoteTitle, content: $newNoteContent, isPresented: $isShowingNoteSheet, action: self.$sheetAction, onSave: saveNote)
        })
    }
    
    func autoSave() {
        if (!newNoteTitle.isEmpty || !newNoteContent.isEmpty){
            viewModel.data = Note(title: newNoteTitle, content: newNoteContent)
            viewModel.saveNote(title: newNoteTitle, content: newNoteContent, isEditingNote: isEditingNote, selectedNote: selectedNote)
        }
    }
    
    func saveNote() {
        autoSave()
        newNoteTitle = ""
        newNoteContent = ""
        isEditingNote = false
        isShowingNoteSheet = false
    }
}

struct NoteSheet: View {
    @Binding var title: String
    @Binding var content: String
    @Binding var isPresented: Bool
    @Binding var action: SheetAction

    let onSave: () -> Void

    var body: some View {
        NavigationView {
            VStack {
                TextField("Title", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                Divider()
                
                TextEditor(text: $content)
                    .padding()
                Button(action: onSave) {
                    Text("Save")
                        .font(.headline)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .padding()
                
                Spacer()
            }
            .navigationTitle("New Note")
            .navigationBarItems(trailing: Button("Cancel") {
                isPresented = false
                self.action = .cancel
            })
        }
        .onAppear {
            action = .nothing
        }
    }
}

enum SheetAction {
    case cancel
    case nothing
}
