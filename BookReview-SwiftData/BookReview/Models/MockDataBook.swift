//
//  MockDataBook.swift
//  BookReview
//
//  Created by Lionel Ng on 18/5/25.
//

import SwiftData
import SwiftUI

// A struct for MockData for SwiftData
struct MockDataBook: PreviewModifier {
    func body(content: Content, context: ModelContainer) -> some View {
        content
            .modelContainer(context)
    }
    
    static func makeSharedContext() async throws -> ModelContainer {
        let container = try! ModelContainer(
            for: Book.self, // Replace name of the model in here
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        // Insert objects here, define the model.swift for SwiftData as needed
        Book.mockBooks.forEach { book in
            container.mainContext.insert(book)
        }
        
        return container
    }
}

extension PreviewTrait where T == Preview.ViewTraits {
    static var mockData: Self = .modifier(MockDataBook())
}
