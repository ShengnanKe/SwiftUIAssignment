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
                Text("Search Images")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

                Spacer()
            }
            .padding()
            .navigationTitle("Image Search Page")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchQuery, prompt: "Search for images")
            .onSubmit(of: .search) {
                if !viewModel.searchQuery.isEmpty {
                    resultsViewModel = viewModel.performSearch()
                    showResults = true
                }
            }
            .navigationDestination(isPresented: $showResults) {
                if let resultsViewModel = resultsViewModel {
                    ImageSearchResultsView(viewModel: resultsViewModel)
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
