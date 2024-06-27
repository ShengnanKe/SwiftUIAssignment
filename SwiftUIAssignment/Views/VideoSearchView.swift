//
//  VideoSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/19/24.
//

import SwiftUI

struct VideoSearchView: View {
    @State private var showResults = false
    @State private var searchQuery: String = ""
    
    var body: some View {
        NavigationStack {
            VStack {
                SearchHeader(title: "Search Videos")
                
                Spacer()
                
                NavigationLink(
                    destination: VideoSearchResultsView(searchQuery: searchQuery),
                    isActive: $showResults
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Video Search Page")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, prompt: "Search for videos")
            .onSubmit(of: .search) {
                if !searchQuery.isEmpty {
                    showResults = true
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
