//
//  ImageSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchView: View {
    
    @State private var showResults = false
    // track when to show the results
    @StateObject private var resultsViewModel = ImageSearchResultsViewModel()


    var body: some View {
        NavigationStack {
            VStack {
                SearchHeader(title: "Search Images")
                
                Spacer()
                
                NavigationLink(
                    destination: ImageSearchResultsView(viewModel: resultsViewModel),
                
                    isActive: $showResults
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Image Search Page")
            .navigationBarTitleDisplayMode(.inline)
            
            .searchable(text: $resultsViewModel.searchQuery, prompt: "Search for images")
            .onSubmit(of: .search) {
                if !resultsViewModel.searchQuery.isEmpty {
                    Task {
                        await resultsViewModel.searchImages()
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
