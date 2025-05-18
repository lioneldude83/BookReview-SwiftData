//
//  InjectSampleDataView.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct InjectSampleDataView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var books: [Book] // Fetch existing books
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            Text("Developer Tools")
                .font(.title2)
                .padding(.vertical)
            
            Button(action: {
                DataManager.shared.injectSampleData(context: modelContext)
                WidgetCenter.shared.reloadAllTimelines()
            }) {
                Label("Inject Sample Data", systemImage: "syringe")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(books.isEmpty ? Color.blue : Color.gray))
                    .foregroundColor(.white)
            }
            .navigationTitle("Inject Data")
            .disabled(!books.isEmpty)
            
            Button(action: {
                showDeleteAlert = true
            }) {
                Label("Delete All Books", systemImage: "trash")
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(Capsule().fill(books.isEmpty ? Color.gray : Color.red))
                    .foregroundColor(.white)
            }
            .disabled(books.isEmpty)
            .alert("Delete all books?", isPresented: $showDeleteAlert) {
                Button("Delete", role: .destructive) {
                    DataManager.shared.deleteAllBooks(context: modelContext)
                    WidgetCenter.shared.reloadAllTimelines()
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("This action cannot be undone.")
            }
        }
    }
}

#Preview {
    InjectSampleDataView()
        .modelContainer(for: Book.self, inMemory: true)
}
