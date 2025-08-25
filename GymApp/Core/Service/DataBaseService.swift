//
//  DataBaseService.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import Foundation
import Observation
import FirebaseDatabase
import FirebaseAuth
import UIKit
import FirebaseStorage

@Observable
class DataBaseService {
    static let shared = DataBaseService()
    private let SCORE_MULTIPLIER:Double=10.0
    var activities: [Activity] = []
    var ranking:[(user:String,points:Double)]=[] // garder les points de chaque user
    
    private let  ref = Database.database().reference().child("activities") // pour chercher une key dans realtime db, si plusieurs creer autant de reference
    
    private let storageRef = Storage.storage().reference() // reference vers le storage
    var images:[UpdateImage]=[]  //array des images
    private let dbRef=Database.database().reference() //refence globale vers la base de données
    
    init() {
        getActivities( ) //charger les acivites de la bd
        //getRanking()
     }
    func addActivity(type:String, minutes:Int, user:User){
        let key=ref.childByAutoId().key ?? UUID().uuidString
        let act=Activity(
            id:key,
            userId:user.uid,
            userName:user.email ?? "unknown user",
            type:type,
            minutes:minutes
        )
        ref.child(key).setValue(act.toDictionary()) //conversion en json avant de pousser vers firebase
    }
    func getActivities(){
        ref.observe(.value) { snapshot in
            var list:[Activity]=[]
            for child in snapshot.children {
              if let childSnapshot = child as? DataSnapshot,
                 let a=Activity(snapshot: childSnapshot){
                  list.append(a)
              }
                           
            }
            self.activities=list.sorted(by: {$0.timestamp > $1.timestamp})
            self.getRanking()
        }
        
    }
    func deleteActivity(activity:Activity){
        ref.child(activity.id).removeValue()
    }
    
    func updateActivity(activity:Activity, minutes:Int, type:String){
        ref.child(activity.id).updateChildValues(["minutes":minutes,"type":type])
    }
    
    private func getRanking(){
        var totals:[String:Double]=[:]
        for activity in activities{
            totals[activity.userName,default: 0]+=Double(activity.minutes)*SCORE_MULTIPLIER
        }
        let sortedArray=totals.sorted {$0.value > $1.value}
        self.ranking=sortedArray.map {(user:$0.key,points:$0.value)}
        
    }
    
    //storage image
    func uploadImage(image:UIImage, description:String, completion: @escaping (Result<Void, Error>) -> Void) {
     //conversion image en jpg
        guard let imageData=image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "image conversion error", code: 0)))
            return
        }
        let idMage=UUID().uuidString
        let imageRef = self.storageRef.child("images/\(idMage).jpg")
        let metadataImage:StorageMetadata = StorageMetadata()
        metadataImage.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadataImage) { (metadata, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            imageRef.downloadURL { (url, error) in
                guard let url = url else {
                    completion(.failure(NSError(domain: "image url error", code: 0)))
                    return
                }
                self.saveImageInfo(imageId: idMage, description: description, url: url)
                completion(.success(()))
            }
        }
        
        
     
    }
    //envoie la data dans la realtime data base
    func saveImageInfo(imageId:String, description:String,url:URL){
        let data:[String:Any]=["imageId":imageId,"description":description,"url":url.absoluteString]
        dbRef.child("images").child(imageId).setValue(data)
    }
    
    //fonction pour afficher all les images depuis realtime database
    func getAllImages(completion: @escaping ([UpdateImage]) -> Void){
       
//        dbRef.child("images").observe(.value) { (snapshot) in
//            var fetchedImages:[UpdateImage]=[]
//            for child in snapshot.children{
//                if let snapshot=child as? DataSnapshot,
//                   let value=snapshot.value as? [String:Any],
//                   
//                
//                    
//                
//                
//                let imageId=child.key
//                let description=value["description"] as! String
//                let urlString=value["url"] as! String
//            }
//            self.images=fetchedImages
//        }
        
        
    }
    
}
