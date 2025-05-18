//
//  ShowAddBookIntent.swift
//  BookReview
//
//  Created by Lionel Ng on 18/5/25.
//

import AppIntents

struct ShowAddBookIntent: AppIntent {
    static var title: LocalizedStringResource { "Add Book" }
    static var openAppWhenRun = true
    
    @MainActor
    func perform() async throws -> some IntentResult {
        // Post the notification for "ShowAddBook"
        NotificationCenter.default.post(name: NSNotification.Name("ShowAddBook"), object: nil)
        return .result()
    }
}
