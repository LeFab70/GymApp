//
//  Activity.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import Foundation
import FirebaseDatabase
class Activity: Identifiable {
    let id: String
    let userId: String
    let userName: String
    let type: String
    let minutes: Int
    let timestamp: TimeInterval
    
    // Nouveaux champs pour image
    let imageId: String?
    let imageDescription: String?
    let imageUrl: String?
    
    init(
        id: String,
        userId: String,
        userName: String,
        type: String,
        minutes: Int,
        timestamp: TimeInterval = Date().timeIntervalSince1970,
        imageId: String? = nil,
        imageDescription: String? = nil,
        imageUrl: String? = nil
    ) {
        self.id = id
        self.userId = userId
        self.userName = userName
        self.type = type
        self.minutes = minutes
        self.timestamp = timestamp
        self.imageId = imageId
        self.imageDescription = imageDescription
        self.imageUrl = imageUrl
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: Any],
              let userId = dict["userId"] as? String,
              let userName = dict["userName"] as? String,
              let type = dict["type"] as? String,
              let minutes = dict["minutes"] as? Int,
              let timestamp = dict["timestamp"] as? TimeInterval else {
            return nil
        }
        
        self.id = dict["id"] as? String ?? snapshot.key
        self.userId = userId
        self.userName = userName
        self.type = type
        self.minutes = minutes
        self.timestamp = timestamp
        
        // Charger aussi les infos image si elles existent
        self.imageId = dict["imageId"] as? String
        self.imageDescription = dict["imageDescription"] as? String
        self.imageUrl = dict["imageUrl"] as? String
    }
    
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "id": id,
            "userId": userId,
            "userName": userName,
            "type": type,
            "minutes": minutes,
            "timestamp": timestamp
        ]
        
        if let imageId = imageId {
            dict["imageId"] = imageId
        }
        if let imageDescription = imageDescription {
            dict["imageDescription"] = imageDescription
        }
        if let imageUrl = imageUrl {
            dict["imageUrl"] = imageUrl
        }
        
        return dict
    }
}

