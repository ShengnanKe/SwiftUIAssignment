//
//  ImageDetailView.swift
//  SwiftUIAssignment
//
//  Created by KKNANXX on 6/20/24.
//

import SwiftUI

struct ImageDetailView: View {
    @StateObject var viewModel: ImageDetailViewModel

    var body: some View {
        VStack {
            if viewModel.isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            } else if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .padding()
            }

            Text(viewModel.photo.photographer)
                .font(.title)
                .padding()

            Text(viewModel.photo.alt)
                .font(.body)
                .padding()

            Spacer()
        }
        .navigationTitle("Image Detail")
        .onAppear {
            viewModel.loadImage()
        }
    }
}

//struct ImageDetailView_Previews: PreviewProvider {
//    static var previews: some View {
//        let photo = MediaPhoto(
//            id: 1, width: 100, height: 100, url: "https://via.placeholder.com/100", photographer: "Photographer Name",
//            photographerUrl: "https://via.placeholder.com", photographerId: 123, avgColor: "#CCCCCC",
//            src: PhotoSrc(original: "https://via.placeholder.com/500", small: "https://via.placeholder.com/100",
//                          large: "https://via.placeholder.com/500"), liked: false, alt: "Sample Image"
//        )
//        ImageDetailView(viewModel: ImageDetailViewModel(photo: photo))
//    }
//}
