//
//  AnalyseImage.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-25.
//

import Foundation
import Vision
import CoreML
import UIKit
class AnalyseImage{
    static var shared = AnalyseImage()
    private var model: VNCoreMLModel?
    init() {
        let config = MLModelConfiguration()
        guard let mlModel=try? MobileNetV2(configuration: config).model else {
            return
        }
        self.model=try? VNCoreMLModel(for: mlModel)
        
    }
    func reconizeObject(image: UIImage, completion:@escaping ([String]?) -> Void){
        guard let model=model,let cgImage=image.cgImage else {
            completion(nil)
            return
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            guard let results = request.results as? [VNClassificationObservation] else {
                completion(nil)
                return
            }
            let recognizedObjects = results.prefix(1).map{("\($0.identifier) - \($0.confidence*100) %")}
            completion(recognizedObjects)
        }
        
        let handler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        do {
            try handler.perform([request])
        } catch {
            print("Failed to perform request: \(error)")
            completion(nil)
        }
        
    }
}
