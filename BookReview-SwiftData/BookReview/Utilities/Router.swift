//
//  Router.swift
//  BookReview
//
//  Created by Lionel Ng on 16/5/25.
//

import Foundation

@Observable
class Router {
    var selectedBookID: UUID?
    
    init(selectedBookID: UUID? = nil) {
        self.selectedBookID = selectedBookID
    }
}
