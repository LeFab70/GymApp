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
@Observable
class DataBaseService {
    static let shared = DataBaseService()
    private let SCORE_MULTIPLIER:Double=10.0
    var activities: [Activity] = []
    var ranking:[(user:String,points:Double)]=[] // garder les points de chaque user
    
    private let  ref = Database.database().reference().child("activities") // pour chercher une key dans realtime db, si plusieurs creer autant de reference
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
}
