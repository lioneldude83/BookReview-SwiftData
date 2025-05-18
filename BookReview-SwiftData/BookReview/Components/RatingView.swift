//
//  RatingView.swift
//  BookReview
//
//  Created by Lionel Ng on 21/3/25.
//

import SwiftUI

struct RatingView: View {
    @Binding var rating: Int

    init(rating: Binding<Int>) {
        self._rating = rating
    }

    var body: some View {
        Stepper("Rating: \(rating)", value: $rating, in: 0...5)
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var previewRating = 3

        var body: some View {
            RatingView(rating: $previewRating)
        }
    }
    return PreviewWrapper()
}
