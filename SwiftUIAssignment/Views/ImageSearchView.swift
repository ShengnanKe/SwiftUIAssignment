//
//  ImageSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchView: View {
    @StateObject private var viewModel = ImageSearchViewModel()
    @State private var searchText = ""
    @State private var showResults = false
    
    var body: some View {
        NavigationStack {
            VStack {
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
                
                Text("Search Images")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .navigationTitle("Image Search Page")
            //.navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for images")
            .onSubmit(of: .search) {
                viewModel.searchQuery = searchText
                if !searchText.isEmpty {
                    viewModel.searchImages(query: searchText)
                    showResults = true
                }
            }
            .navigationDestination(isPresented: $showResults) {
                ImageSearchResultsView(query: searchText)
            }
        }
    }
}

//struct ImageSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        ImageSearchView()
//    }
//}
