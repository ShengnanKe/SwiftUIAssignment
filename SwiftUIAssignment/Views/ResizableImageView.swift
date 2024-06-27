//
//  ResizableImageView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/26/24.
//

import SwiftUI

struct ResizableImageView: View {
    var image: Image

    var body: some View {
        image
            .resizable()
            .frame(width: 100, height: 100)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
