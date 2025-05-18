//
//  Book.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import Foundation
import SwiftData

@Model
class Book: Identifiable {
    var id: UUID = UUID()
    var title: String
    var author: String
    var review: String?
    var rating: Int
    var reviewDate: Date
    
    init(title: String, author: String, review: String? = nil, rating: Int, reviewDate: Date = Date()) {
        self.title = title
        self.author = author
        self.review = review
        self.rating = rating
        self.reviewDate = reviewDate
    }
    
    // Mock Counters for Preview
    static var mockBooks: [Book] {
        [
            Book(title: "Swift Programming", author: "Apple", review: "Great book!", rating: 5, reviewDate: Date()), // Today
            Book(title: "iOS Development", author: "John Appleseed", review: "Helpful guide.", rating: 4, reviewDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!), // Yesterday
            Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", review: "A hilarious and mind-bending science fiction classic.", rating: 4, reviewDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!), // One month ago
            Book(title: "Pride and Prejudice", author: "Jane Austen", review: "A classic romance novel with witty social commentary.", rating: 5, reviewDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!), // One year ago
            Book(title: "1984", author: "George Orwell", review: "A dystopian novel that explores themes of totalitarianism and surveillance.", rating: 4, reviewDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!), // 3 days ago
            Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", review: "An epic fantasy adventure.", rating: 5, reviewDate: Calendar.current.date(byAdding: .month, value: -2, to: Date())!), // Two months ago
            Book(title: "Moby Dick", author: "Herman Melville", review: "The story of Captain Ahab's obsessive quest for revenge on a great white whale.", rating: 3, reviewDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!) // Two years ago
        ]
    }
}
