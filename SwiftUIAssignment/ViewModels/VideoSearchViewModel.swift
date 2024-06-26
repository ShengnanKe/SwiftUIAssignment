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

    func performSearch() async -> VideoSearchResultsViewModel {
        let resultsViewModel = VideoSearchResultsViewModel(query: searchQuery)
        await resultsViewModel.searchVideos()
        return resultsViewModel
    }

    func searchWithDelay() {
        debounceTimer?.invalidate()
        debounceTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            Task {
                guard let self = self else { return }
                await self.performSearch()
            }
        }
    }
}
