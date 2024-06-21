//
//  VideoSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import SwiftUI

struct VideoSearchView: View {
    @StateObject private var viewModel = VideoSearchViewModel()
    @State private var searchText = ""
    @State private var showResults = false

    var body: some View {
        NavigationStack {
            VStack {
                Text("Search Videos")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }

            }
            .padding()
            .navigationTitle("Video Search Page")
            //.navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchText, prompt: "Search for videos")
            .onSubmit(of: .search) {
                viewModel.searchQuery = searchText
                if !searchText.isEmpty {
                    viewModel.searchVideos(query: searchText)
                    showResults = true
                }
            }
            .navigationDestination(isPresented: $showResults) {
                VideoSearchResultsView(query: searchText)
            }
        }
    }
}
//
//struct VideoSearchView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoSearchView()
//    }
//}
