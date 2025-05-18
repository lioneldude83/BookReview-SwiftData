#  BookReview

This BookReviewApp uses SwiftData.

The model is stored in Book, and using SwiftData makes it easy to Create, Read, Update and Delete data.
The advantage that SwiftData has over Core Data is that any changes to data is automatically saved.
Not needed to create complicated properties and class files.

In BookListView, the list of books are displayed.
The user can add books, view detail of the book, edit book, and also delete book by swiping to delete.

A developer tab called InjectSampleDataView is added so that sample book data can be added. Additionally, a delete all books is also included.
A DataManager is also included, with functions fetchBook (sorted by title), addBook, deleteBook and deleteAllBooks.
SortView to sort books by title or by date.

Project management:
Folders are:
Models -> Book will be the model here
Views -> For all the views in this project
Components -> RatingView (stepper to set rating of book)
Utilities -> DataManager, InjectSampleDataView, SortView


## Refactored to NavigationSplitView

Another alternative way of structuring NavigationSplitView:

add a @State private var selectedItem: Item? = nil

NavigationSplitView {
    List(items, selection: $selectedItem) { item in
        NavigationLink(value: item) {
            ListRowView(variable: item)
                
        }
    }
    .navigationTitle("Item")
    .navigationDestination(for: Item.self) { item in
        DetailView(variable: item)
    }
} detail: {
    if let item = selectedItem {
        DetailView(variable: item)
    } else {
        Text("Select an item")
    }
}


Added Widget functionality to display systemMedium and systemLarge Widget families. Fetch limit for SwiftData set to 3 for systemMedium, else set to 6 for systemLarge.

URL deeplinks are working, they will link to the selectedBook in the BookListView.

Need to declare into the info.plist by adding URL Types, then add URL Schemes, then set the string to "myappname", where the app name is unique to the app.

## Immediately Invoked Closure Expression (IICE)

In the Widget Provider, declare and initialize the ModelContainer as a variable.

    // Since Provider is not a View, it cannot receive @Environment(\.modelContext)
    // Declare and initialize ModelContainer for the Provider
    var container: ModelContainer = {
        try! ModelContainer(for: Book.self)
    }() // Initialize here with the () brackets, known as immediately invoked closure expression (IICE) in Swift

Deletion logic explained:

We have the list below:

    @State private var books: [Book] = []

    List(books, id: \.id, selection: $selectedBook) { book in
        NavigationLink(value: book) {
            BookListRow(book: book)
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button(role: .destructive) {
                        modelContext.delete(book)
                        try? modelContext.save()
                        fetchAndSortBooks() // Manual refresh required to update local state variable books array
                        selectedBook = nil
                        WidgetCenter.shared.reloadAllTimelines()
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                }
        }
    }
    


Updated the WidgetCenter reload timelines to the main App onChange block. That is the most reliable. If the WidgetCenter reload timelines is placed in the if let { } of the delete book logic, the reloading of the Widget data is not as reliable.


Added an AppIntent to add a new book review that can be used in the Widget when books list is empty and also from the Shortcuts app. The intent will post a notification, and in the main app receive the notification and change the boolean showingAddBook to true to trigger the AddBook sheet. However when using Siri with the spoken phrases, only the app launches, but not the Addbook sheet.

Updated some minor UI fixes. Moved the sort function to a menu in the BookListView in the top bar leading.

When saving a new book, the title cannot be empty. Likewise when editing, the title should not be empty.
