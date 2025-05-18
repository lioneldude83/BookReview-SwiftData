//
//  DataManager.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftData
import SwiftUI

class DataManager {
    static let shared = DataManager()
    
    private init() {} // Prevents accidental instantiation
    
    func fetchBooks(using context: ModelContext) -> [Book] {
        let books = (try? context.fetch(FetchDescriptor<Book>())) ?? []
        return books.sorted { $0.title.localizedStandardCompare($1.title) == .orderedAscending }
        //return books.sorted { $0.title.compare($1.title, options: .literal) == .orderedAscending } // Use options: .literal to sort by ASCII
    }
    
    func fetchBooksSortedByDate(using context: ModelContext) -> [Book] {
        let books = (try? context.fetch(FetchDescriptor<Book>())) ?? []
        return books.sorted { ($0.reviewDate) > ($1.reviewDate) }
    }
    
    func addBook(title: String, author: String, rating: Int, review: String?, reviewDate: Date, context: ModelContext) {
        let newBook = Book(title: title, author: author, review: review, rating: rating, reviewDate: reviewDate)
        context.insert(newBook)
        try? context.save()
    }
    
    func deleteBook(_ book: Book, context: ModelContext) {
        context.delete(book)
    }
    
    func deleteAllBooks(context: ModelContext) {
        let books = fetchBooks(using: context)
        books.forEach { context.delete($0) }
    }
    
    func injectSampleData(context: ModelContext) {
        let sampleBooks = [
            Book(title: "Swift Programming", author: "Apple", review: "Great book!", rating: 5, reviewDate: Date()), // Today
            Book(title: "iOS Development", author: "John Appleseed", review: "Helpful guide.", rating: 4, reviewDate: Calendar.current.date(byAdding: .day, value: -1, to: Date())!), // Yesterday
            Book(title: "The Hitchhiker's Guide to the Galaxy", author: "Douglas Adams", review: "A hilarious and mind-bending science fiction classic.", rating: 4, reviewDate: Calendar.current.date(byAdding: .month, value: -1, to: Date())!), // One month ago
            Book(title: "Pride and Prejudice", author: "Jane Austen", review: "A classic romance novel with witty social commentary.", rating: 5, reviewDate: Calendar.current.date(byAdding: .year, value: -1, to: Date())!), // One year ago
            Book(title: "1984", author: "George Orwell", review: "A dystopian novel that explores themes of totalitarianism and surveillance.", rating: 4, reviewDate: Calendar.current.date(byAdding: .day, value: -3, to: Date())!), // 3 days ago
            Book(title: "The Lord of the Rings", author: "J.R.R. Tolkien", review: "An epic fantasy adventure.", rating: 5, reviewDate: Calendar.current.date(byAdding: .month, value: -2, to: Date())!), // Two months ago
            Book(title: "Moby Dick", author: "Herman Melville", review: "The story of Captain Ahab's obsessive quest for revenge on a great white whale.", rating: 3, reviewDate: Calendar.current.date(byAdding: .year, value: -2, to: Date())!) // Two years ago
        ]
        sampleBooks.forEach { context.insert($0) }
    }
}
