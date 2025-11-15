//
//  ContentView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 15.11.2025.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var context
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Note.dateCreated, ascending: false)],
        animation: .default
    ) private var notes: FetchedResults<Note>

    @State private var showingNewNote = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(note.title ?? "Untitled")
                            .font(.headline)

                        Text(note.content ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let date = note.dateCreated {
                            Text(date.formatted(date: .numeric, time: .shortened))
                                .font(.caption2)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
                .onDelete(perform: deleteNotes)
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showingNewNote = true
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .font(.system(size: 24))
                    }
                }
            }
            .sheet(isPresented: $showingNewNote) {
                NewNoteView()
            }
        }
    }

    private func deleteNotes(at offsets: IndexSet) {
        offsets.map { notes[$0] }.forEach(context.delete)

        do {
            try context.save()
        } catch {
            print("Delete error: \(error)")
        }
    }
}

