//
//  LoadingView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/26/24.
//

import SwiftUI

struct LoadingView: View {
    
    var body: some View {
        ProgressView()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
