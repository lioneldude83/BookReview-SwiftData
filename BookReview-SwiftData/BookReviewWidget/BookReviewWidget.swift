//
//  BookReviewWidget.swift
//  BookReviewWidget
//
//  Created by Lionel Ng on 15/5/25.
//

import WidgetKit
import SwiftUI
import SwiftData

struct Provider: TimelineProvider {
    // Since Provider is not a View, it cannot receive @Environment(\.modelContext)
    // Declare and initialize ModelContainer for the Provider, see Readme
    var container: ModelContainer = {
        try! ModelContainer(for: Book.self)
    }()
    
    func placeholder(in context: Context) -> BookEntry {
        BookEntry(date: Date(), books: [])
    }
    
    func getSnapshot(in context: Context, completion: @escaping (BookEntry) -> ()) {
        let currentDate = Date()
        Task { @MainActor in
            // Set limit to 3 for systemMedium, else 6 for systemLarge
            let limit = context.family == .systemMedium ? 3 : 6
            let allBooks = try getBooks(limit: limit) // Pass in the limit here
            let entry = BookEntry(date: currentDate, books: allBooks)
            completion(entry)
        }
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        Task { @MainActor in
            let limit = context.family == .systemMedium ? 3 : 6
            let allBooks = try getBooks(limit: limit) // Pass in the limit here
            let entry = BookEntry(date: currentDate, books: allBooks)
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
    
    // Runs on main thread when dealing with UI-related updates or state that must
    // stay synchronized with the main run loop, especially for SwiftUI and WidgetKit contexts
    @MainActor
    func getBooks(limit: Int) throws -> [Book] {
        let sort = [SortDescriptor(\Book.reviewDate, order: .reverse)]
        var descriptor = FetchDescriptor<Book>(sortBy: sort)
        descriptor.fetchLimit = limit // Set the fetch limit
        let allBooks = try? container.mainContext.fetch(descriptor)
        return allBooks ?? []
    }
}

struct BookEntry: TimelineEntry {
    let date: Date
    let books: [Book]
}

struct BookReviewWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        if entry.books.isEmpty {
            ContentUnavailableView {
                Text("No Books added yet")
            } actions: {
                // Note that AppIntents does not need to be imported, but ShowAddBookIntent needs to have WidgetExtension as target
                Button(intent: ShowAddBookIntent()) {
                    Label("Add a book review", systemImage: "plus.circle")
                        .font(.title3)
                }
            }
        } else {
            ForEach(entry.books, id: \.id) { book in
                Link(destination: URL(string: "bookreviewapp://book/\(book.id.uuidString)")!) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(book.title)
                            .font(.title3)
                        HStack(spacing: 2) {
                            ForEach(1...5, id: \.self) { index in
                                Image(systemName: index <= book.rating ? "star.fill" : "star")
                                    .foregroundColor(.yellow)
                            }
                        }
                        .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 12)
                    
                }
                
                Divider()
                    .frame(height: 1)
                    .frame(maxWidth: .infinity)
                    .background(Color.gray.opacity(0.15))
            }
        }
    }
}

struct BookReviewWidget: Widget {
    let kind: String = "BookReviewWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BookReviewWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
            
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemMedium, .systemLarge]) // Declare supported families here
    }
}

#Preview(as: .systemMedium) {
    BookReviewWidget()
} timeline: {
    BookEntry(
        date: .now,
        books: [
            // Preview will not respect the fetch limit declared in getBooks(limit:)
            Book(title: "Test Title 1", author: "Test Author", rating: 3),
            Book(title: "Test Title 2", author: "Test Author", rating: 5),
            Book(title: "Test Title 3", author: "Test Author", rating: 2),
            Book(title: "Test Title 4", author: "Test Author", rating: 4)
        ]
    )
    BookEntry(date: .now, books: [])
}
