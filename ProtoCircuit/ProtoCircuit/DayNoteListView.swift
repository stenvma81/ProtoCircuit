//
//  DayNoteListView.swift
//  ProtoCircuit
//
//  Created by Matti Stenvall on 20.11.2025.
//

import SwiftUI

struct DayNotesListView: View {
    let date: Date
    let notes: [Note]

    var body: some View {
        NavigationStack {
            List {
                ForEach(notes) { note in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(note.title ?? "Untitled")
                            .font(.headline)

                        if let content = note.content {
                            Text(content)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .lineLimit(3)
                        }

                        if let created = note.dateCreated {
                            Text(created.formatted(date: .complete, time: .shortened))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .navigationTitle(date.formatted(date: .long, time: .omitted))
        }
    }
}
