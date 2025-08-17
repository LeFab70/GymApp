//
//  Activity.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import Foundation
import FirebaseDatabase
class Activity :Identifiable{
    let id:String
    let userId:String
    let userName:String
    let type:String
    let minutes:Int
    let timestamp:TimeInterval
    init(id: String, userId: String, userName: String, type: String, minutes: Int, timestamp: TimeInterval=Date().timeIntervalSince1970) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.type = type
        self.minutes = minutes
        self.timestamp = timestamp
    }
    
    init?(snapshot:DataSnapshot){
        
        guard let dict = snapshot.value as? [String:Any], let userId=dict["userId"] as? String, let userName=dict["userName"] as? String, let type=dict["type"] as? String, let minutes=dict["minutes"] as? Int, let timestamp=dict["timestamp"] as? TimeInterval else {
                return nil
        }
        self.id = dict["id"] as? String ?? snapshot.key
        self.userId = userId
        self.userName = userName
        self.type = type
        self.minutes = minutes
        self.timestamp = timestamp
    }
    
    func toDictionary() -> [String:Any]{
        return [
            "id":id,
            "userId":userId,
            "userName":userName,
            "type":type,
            "minutes":minutes,
            "timestamp":timestamp
        ]
    }
}
