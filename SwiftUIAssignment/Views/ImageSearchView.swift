//
//  ImageSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

import SwiftUI

struct ImageSearchView: View {
    @State private var showResults = false
    @State private var searchQuery: String = ""

    var body: some View {
        NavigationStack {
            VStack {
                SearchHeader(title: "Search Images")
                
                Spacer()
                
                NavigationLink(
                    destination: ImageSearchResultsView(searchQuery: searchQuery),
                    isActive: $showResults
                ) {
                    EmptyView()
                }
            }
            .padding()
            .navigationTitle("Image Search Page")
            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $searchQuery, prompt: "Search for images")
            .onSubmit(of: .search) {
                if !searchQuery.isEmpty {
                    showResults = true
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
