//
//  VideoSearchViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

@MainActor
class VideoSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var errorMessage: String?
    private var debounceTimer: Timer?

    func performSearch() -> VideoSearchResultsViewModel {
        let resultsViewModel = VideoSearchResultsViewModel(query: searchQuery)
        resultsViewModel.searchVideos()
        return resultsViewModel
    }

    func searchWithDelay() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { _ in
            self.performSearch()
        }
    }
}
