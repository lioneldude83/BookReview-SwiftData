//
//  EditBookView.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI
import SwiftData

struct EditBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var book: Book
    @State private var editedBook: Book
    @State private var showDiscardAlert = false
    
    init(book: Book) {
        self._book = Bindable(wrappedValue: book)
        self._editedBook = State(initialValue: Book(
            title: book.title,
            author: book.author,
            review: book.review,
            rating: book.rating,
            reviewDate: book.reviewDate
        ))
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Title", text: $editedBook.title)
                        .padding(.horizontal)
                    TextField("Author", text: $editedBook.author)
                        .padding(.horizontal)
                    VStack(alignment: .leading) {
                        Text("Review")
                            .padding(.horizontal)
                        TextEditor(text: Binding(
                            get: { editedBook.review ?? "" },
                            set: { editedBook.review = $0 }
                        ))
                        .frame(minHeight: 100)
                        .padding(.horizontal, 8)
                    }
                    RatingView(rating: $editedBook.rating)
                        .padding()
                    DatePicker("Review Date", selection: $editedBook.reviewDate, displayedComponents: .date)
                        .padding(.horizontal)
                }
                .listRowInsets(EdgeInsets()) // Remove row insets
            }
            .navigationTitle("Edit Book")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let trimmedTitle = editedBook.title.trimmingCharacters(in: .whitespaces)
                        guard !trimmedTitle.isEmpty else {
                            return
                        }
                        book.title = trimmedTitle
                        book.author = editedBook.author
                        book.review = editedBook.review
                        book.rating = editedBook.rating
                        book.reviewDate = editedBook.reviewDate
                        dismiss()
                    }
                    .disabled(editedBook.title.trimmingCharacters(in: .whitespaces).isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        showDiscardAlert = true
                    }
                }
            }
            .alert("Discard changes?", isPresented: $showDiscardAlert) {
                Button("Discard Changes", role: .destructive) {
                    dismiss()
                }
                Button("Keep Editing", role: .cancel) { }
            } message: {
                Text("Your edits will be lost if you discard them.")
            }
        }
    }
}

#Preview {
    let dummyBook = Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", review: "An epic fantasy adventure.", rating: 5, reviewDate: Date())
    return EditBookView(book: dummyBook)
        .modelContainer(for: Book.self, inMemory: true)
}
