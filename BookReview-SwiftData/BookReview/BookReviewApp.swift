//
//  BookReviewApp.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI
import SwiftData
import WidgetKit
import AppIntents

@main
struct BookReviewApp: App {
    @State private var router = Router()
    @Environment(\.scenePhase) var scenePhase
    // State variable to show add book
    @State private var showingAddBook = false
    
    var body: some Scene {
        WindowGroup {
            TabView {
                BookListView(showingAddBook: $showingAddBook)
                    .tabItem {
                        Label("Books", systemImage: "books.vertical.fill")
                    }
                    .onChange(of: scenePhase) { _, newValue in
                        if newValue == .active || newValue == .inactive {
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    }
                    .onOpenURL { url in
                        guard url.scheme == "bookreviewapp",
                              url.host == "book",
                              let idString = url.pathComponents.dropFirst().first,
                              let uuid = UUID(uuidString: idString) else { return }
                        
                        router.selectedBookID = uuid
                        print("URL opened: \(url)")
                    }
                
                InjectSampleDataView()
                    .tabItem {
                        Label("Inject Data", systemImage: "hammer.fill")
                    }
            }
            .modelContainer(for: Book.self) // Apply modelContainer to TabView
            .environment(router)
            .onReceive(NotificationCenter.default.publisher(for: NSNotification.Name("ShowAddBook"))) { _ in
                showingAddBook = true
                print("Received notification to show Add Book sheet")
            }
        }
    }
}
