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

    var body: some View {
        NavigationStack {
            VStack {
                Text("Search Images")
                    .font(.title)
                    .padding()

                SearchBar(text: $viewModel.searchQuery) {
                    showResults = true
                }
                .padding()

                // Use navigationDestination modifier for navigation
                .navigationDestination(isPresented: $showResults) {
                    ImageSearchResultsListView(query: viewModel.searchQuery)
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .padding()
            .navigationTitle("Image Search Page")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchView()
    }
}
