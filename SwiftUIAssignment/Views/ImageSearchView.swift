//
//  ImageSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchView: View {
    @StateObject private var viewModel = ImageSearchViewModel()
    @State private var showResults = false
    @State private var resultsViewModel: ImageSearchResultsViewModel?

    var body: some View {
        NavigationStack {
            VStack {
                SearchHeader(title: "Search Images", errorMessage: viewModel.errorMessage)
                
                Spacer()
                
                NavigationLink(
                    destination: resultsViewModel.map {
                        ImageSearchResultsView(viewModel: $0, query: viewModel.searchQuery)
                    },
                    isActive: $showResults
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Image Search Page")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Search for images")
            .onSubmit(of: .search) {
                if !viewModel.searchQuery.isEmpty {
                    Task {
                        resultsViewModel = await viewModel.performSearch()
                        showResults = true
                    }
                }
            }
        }
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchView()
    }
}
