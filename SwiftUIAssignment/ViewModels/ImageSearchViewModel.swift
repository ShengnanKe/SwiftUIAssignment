//
//  ImageSearchViewModel.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import SwiftUI

@MainActor
class ImageSearchViewModel: ObservableObject {
    @Published var searchQuery: String = ""
    @Published var errorMessage: String?

    func performSearch() -> ImageSearchResultsViewModel {
        let resultsViewModel = ImageSearchResultsViewModel(query: searchQuery)
        Task {
            await resultsViewModel.searchImages(query: searchQuery)
        }
        return resultsViewModel
    }
}


// The search should automatically when user stops typing for 3 seconds.
