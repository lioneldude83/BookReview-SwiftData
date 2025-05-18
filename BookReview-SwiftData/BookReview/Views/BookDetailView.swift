//
//  BookDetailView.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI
import SwiftData

struct BookDetailView: View {
    @Bindable var book: Book
    @Environment(\.modelContext) private var modelContext // Add modelContext
    @State private var showingEditBook = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title).font(.title)
            Text("by \(book.author)").font(.headline)
            
            RatingView(rating: $book.rating)
            if let review = book.review {
                Text("Review: \(review)").padding(.top)
            }
            
            Text("Reviewed on: \(book.reviewDate.formatted(.dateTime.month().day().year()))").padding(.top)
            
            Spacer()
        }
        .padding()
        .navigationTitle(book.title)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingEditBook = true
                }) {
                    Label("Edit Book", systemImage: "pencil")
                }
                .sheet(isPresented: $showingEditBook) {
                    EditBookView(book: book)
                }
            }
        }
    }
}

#Preview {
    let dummyBook = Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", review: "An epic fantasy adventure.", rating: 5, reviewDate: Date())
    return BookDetailView(book: dummyBook)
        .modelContainer(for: Book.self, inMemory: true)
}
