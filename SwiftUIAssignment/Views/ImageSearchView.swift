//
//  ImageSearchView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageSearchView: View {
    @StateObject private var viewModel = ImageSearchViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Search for Images")
                    .font(.largeTitle)
                    .padding()

                SearchBar(text: $viewModel.searchQuery)
                    .padding()
                
                NavigationLink(
                    destination: ImageSearchResultsListView(query: viewModel.searchQuery),
                    label: {
                        Text("Search")
                    }
                )
                .padding()
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                }
            }
            .navigationTitle("Pexels Images")
        }
    }
}

struct ImageSearchView_Previews: PreviewProvider {
    static var previews: some View {
        ImageSearchView()
    }
}
