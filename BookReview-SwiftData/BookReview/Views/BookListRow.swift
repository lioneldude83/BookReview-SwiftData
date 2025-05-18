//
//  BookListRow.swift
//  BookReview
//
//  Created by Lionel Ng on 15/5/25.
//

import SwiftUI
import SwiftData

struct BookListRow: View {
    var book: Book
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(book.title).font(.headline) // Title
            Text("by \(book.author)").font(.subheadline) // Author
            
            HStack(spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= book.rating ? "star.fill" : "star")
                        .foregroundColor(.yellow)
                }
            }
            .font(.caption)
            
            Text(formattedDate(book.reviewDate)) // Date
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

#Preview {
    BookListRow(
        book: Book(
            title: "Sample Book",
            author: "Book Author",
            review: "Great book!",
            rating: 3,
            reviewDate: Calendar.current.date(byAdding: .day, value: -7, to: Date())!
        )
    )
}
