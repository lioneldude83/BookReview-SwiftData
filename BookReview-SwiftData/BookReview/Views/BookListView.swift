//
//  BookListView.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI
import SwiftData

struct BookListView: View {
    @Environment(Router.self) var router
    @Environment(\.modelContext) private var modelContext
    // State variable for books array
    @State private var books: [Book] = []
    // State variable for selected book for the UI
    @State private var selectedBook: Book? = nil
    // Receive the binding to show add book
    @Binding var showingAddBook: Bool
    
    @State private var showingSortOptions = false
    @AppStorage("sortOption") private var sortOption: SortOption = .title
    @State private var id = UUID()
    
    var body: some View {
        NavigationSplitView {
            List(books, id: \.id, selection: $selectedBook) { book in
                NavigationLink(value: book) {
                    BookListRow(book: book)
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                                if let index = books.firstIndex(where: { $0.id == book.id }) {
                                    deleteBooks(offsets: IndexSet([index]))
                                    selectedBook = nil
                                }
                            } label: {
                                Label("Delete", systemImage: "trash")
                            }
                        }
                }
            }
            .id(id) // Declare list as id for UI refresh updates
            .tint(.orange) // Apply tint for the selection in the list
            .listStyle(.inset) // Different listStyles include automatic, plain, insetGrouped, inset, sidebar
            .navigationTitle("Book Reviews")
            .navigationDestination(for: Book.self) { book in
                BookDetailView(book: book)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Menu {
                        Button(action: {
                            sortOption = .title
                            fetchAndSortBooks()
                        }) {
                            Label("Sort by Title", systemImage: "textformat.characters")
                        }
                        Button(action: {
                            sortOption = .date
                            fetchAndSortBooks()
                        }) {
                            Label("Sort by Date", systemImage: "calendar.badge.clock")
                        }
                    } label: {
                        Image(systemName: sortOption == .title ? "textformat.characters" : "calendar.badge.clock")
                    }
                    .help("Sort books by title or date")
                }
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(action: {
                        showingAddBook = true
                    }) {
                        Label("Add Book", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingAddBook, onDismiss: {
                        showingAddBook = false
                        fetchAndSortBooks()
                    }) {
                        AddBookView()
                    }
                }
            }
            .onAppear {
                fetchAndSortBooks()
            }
            .onChange(of: router.selectedBookID) { _, newID in
                if newID != selectedBook?.id {
                    selectedBook = books.first { $0.id == newID }
                    id = UUID() // Refresh the list when selection changes via deep link
                }
            }
        } detail: {
            if let book = selectedBook {
                BookDetailView(book: book)
            } else if books.isEmpty {
                Text("Tap on Plus (+) to add your first book review!")
            } else {
                Text("Select a Book")
            }
        }
    }
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
    
    func fetchAndSortBooks() {
        if sortOption == .title {
            books = DataManager.shared.fetchBooks(using: modelContext)
        } else {
            books = DataManager.shared.fetchBooksSortedByDate(using: modelContext)
        }
    }
    
    func deleteBooks(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                DataManager.shared.deleteBook(books[index], context: modelContext)
            }
            fetchAndSortBooks()
        }
    }
}

enum SortOption: String, CaseIterable, Identifiable {
    case title
    case date
    
    var id: String { self.rawValue } // Add id for Identifiable
}

#Preview {
    let container = try! ModelContainer(
        for: Book.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )
    let context = ModelContext(container)
    
    for book in Book.mockBooks {
        context.insert(book)
    }
    
    return BookListView(showingAddBook: .constant(false))
        .modelContainer(container)
        .environment(Router()) // Pass Router into the Preview
}
