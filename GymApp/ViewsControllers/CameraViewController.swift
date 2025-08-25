//
//  CameraViewController.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-23.
//

//Idee est de retourner une view
import Foundation
import SwiftUI

struct CameraViewController: UIViewControllerRepresentable {
    
   @Binding var capturedImage: UIImage?
    
   func makeUIViewController(context: Context) -> UIViewController {
       let picker = UIImagePickerController()
       picker.sourceType = .photoLibrary  //photoLibrary ici on accede juste a galery pour appareil faut .camera
       picker.mediaTypes = ["public.image"]
       picker.delegate = context.coordinator
       return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        //pas besoin d'ajouter le code ici
        
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    
    class Coordinator: NSObject, UINavigationControllerDelegate,UIImagePickerControllerDelegate  {
      var parent: CameraViewController
        
        init(parent: CameraViewController) {
            self.parent = parent
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.parent.capturedImage = image
            picker.dismiss(animated: true)
        }
        
    }
    
}
