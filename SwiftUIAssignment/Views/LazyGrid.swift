//
//  LazyGrid.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/26/24.
//

import SwiftUI

struct LazyGrid<Content: View, Item: Identifiable>: View {
    var items: [Item]
    var content: (Item) -> Content

    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
            ForEach(items) { item in
                content(item)
            }
        }
        .padding()
    }
}
