//
//  VideoSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import SwiftUI

struct VideoSearchView: View {
    @StateObject private var viewModel = VideoSearchViewModel()
    @State private var showResults = false
    @State private var resultsViewModel: VideoSearchResultsViewModel?

    var body: some View {
        NavigationStack {
            VStack {
                SearchHeader(title: "Search Videos")
                
                Spacer()
                
                NavigationLink(
                    destination: resultsViewModel.map {
                        VideoSearchResultsView(viewModel: $0)
                    },
                    isActive: $showResults
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Video Search Page")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Search for videos")
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

struct VideoSearchView_Previews: PreviewProvider {
    static var previews: some View {
        VideoSearchView()
    }
}
