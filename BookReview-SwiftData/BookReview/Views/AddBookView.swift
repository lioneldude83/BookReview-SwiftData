//
//  AddBookView.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI
import SwiftData
import WidgetKit

struct AddBookView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var review = ""
    @State private var rating = 0
    @State private var reviewDate = Date()
    
    var body: some View {
        NavigationStack{
            Form {
                TextField("Title", text: $title)
                TextField("Author", text: $author)
                TextEditor(text: $review)
                    .frame(minHeight: 100)
                RatingView(rating: $rating)
                DatePicker("Review Date", selection: $reviewDate, displayedComponents: .date)
            }
            .navigationTitle("Add Book")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Save") {
                        let trimmedTitle = title.trimmingCharacters(in: .whitespacesAndNewlines)
                        let trimmedAuthor = author.trimmingCharacters(in: .whitespacesAndNewlines)
                        DataManager.shared.addBook(
                            title: trimmedTitle,
                            author: trimmedAuthor,
                            rating: rating,
                            review: review,
                            reviewDate: reviewDate,
                            context: modelContext
                        )
                        WidgetCenter.shared.reloadAllTimelines() // Reload Widget timelines after book added
                        dismiss()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AddBookView()
}
