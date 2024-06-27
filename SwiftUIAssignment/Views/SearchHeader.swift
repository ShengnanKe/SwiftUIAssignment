//
//  SearchHeader.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/25/24.
//

import SwiftUI

struct SearchHeader: View {
    var title: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding()

            Spacer()
        }
        .padding()
    }
}
