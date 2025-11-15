//
//  NewNoteView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

struct NewNoteView: View {
    @Environment(\.managedObjectContext) private var context
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var content = ""

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Title")) {
                    TextField("Enter title", text: $title)
                }

                Section(header: Text("Content")) {
                    TextEditor(text: $content)
                        .frame(height: 200)
                }
            }
            .navigationTitle("New Note")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") { dismiss() }
                }

                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") { saveNote() }
                        .disabled(title.isEmpty || content.isEmpty)
                }
            }
        }
    }

    func saveNote() {
        let note = Note(context: context)
        note.id = UUID()
        note.title = title
        note.content = content
        note.dateCreated = Date()

        do {
            try context.save()
            dismiss()
        } catch {
            print("Save error: \(error)")
        }
    }
}
