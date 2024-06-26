//
//  SearchResultNavigation.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/25/24.
//

import SwiftUI

struct SearchResultNavigation<Content: View>: View {
    @Binding var showResults: Bool
    let content: () -> Content

    var body: some View {
        NavigationStack {
            content()
            .navigationDestination(isPresented: $showResults) {
                content()
            }
        }
    }
}
