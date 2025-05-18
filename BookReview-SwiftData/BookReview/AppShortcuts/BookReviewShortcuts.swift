//
//  BookReviewShortcuts.swift
//  BookReview
//
//  Created by Lionel Ng on 18/5/25.
//

import AppIntents

struct BookReviewShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: ShowAddBookIntent(),
            phrases: [
                "Add a new review to \(.applicationName)",
                "Add a new review to \(.applicationName) app",
                "Add a new book review to \(.applicationName)",
                "Add a new book review to \(.applicationName) app"
            ],
            shortTitle: "Add Book Review",
            systemImageName: "book.circle"
        )
    }
}
