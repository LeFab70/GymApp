//
//  FeedView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-23.
//

import SwiftUI

struct FeedView: View {
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var isLoading: Bool = false
    @State private var updateStatus: String?
    @State private var description: String = ""
    @State private var firebaseService=DataBaseService.shared
    
    var body: some View {
        NavigationView {
            VStack {
                if let selectedImage = selectedImage {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 300, height: 300)
                        .padding()
                        .clipped()
                    TextField("Description", text: $description)
//                        .rotationEffect(.degrees(90))
                }
                Button("Pick Image", action: {
                    showImagePicker = true
                })
                
                if selectedImage != nil {
                    Button("Upload Image", action: {
                        isLoading = true
                        uploadImage()
                    })
                }
                
                if isLoading {
                    ProgressView()
                }
            }
            .navigationTitle(Text("Feed Image"))
            .sheet(isPresented: $showImagePicker){
                CameraViewController(capturedImage: $selectedImage)
            }
        }
    }
    
    func uploadImage() {
        guard let selectedImage = selectedImage else {
            return
        }
        isLoading = true
        firebaseService.uploadImage(image: selectedImage,description: description) { result in
            isLoading = false
            switch result {
            case .success(let message):
                updateStatus = "Updated successfully"
                self.description=""
                self.selectedImage=nil
            case .failure(let error):
                updateStatus = error.localizedDescription
            }
        }
    }
}

#Preview {
    FeedView()
}
