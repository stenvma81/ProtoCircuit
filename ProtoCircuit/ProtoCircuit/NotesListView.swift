import SwiftUI

struct NotesListView: View {
    @State private var showingNewNote = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                
                Image(systemName: "note.text")
                    .font(.system(size: 50))
                    .foregroundColor(.gray.opacity(0.4))
                
                Text("Notes will appear here")
                    .font(.title3)
                    .foregroundColor(.secondary)

                Text("The real Notes List will be added once the Core Data model is fixed.")
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.gray)
                    .padding(.horizontal)
                
                Button {
                    showingNewNote = true
                } label: {
                    Text("Add Note")
                        .padding(.horizontal, 30)
                        .padding(.vertical, 12)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .navigationTitle("Notes")
        }
        .sheet(isPresented: $showingNewNote) {
            NewNoteView()
        }
    }
}
