//
//  AuthService.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import Foundation
import Observation
import FirebaseAuth
@Observable
class AuthService {
    static let shared = AuthService()
    
    var user:User? //vient de firebaseAuth
    var errorMessage:String?
    
    func register(withEmail email:String, password:String, completion:@escaping (Bool)->(Void)) {
      Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
          self.user=result?.user
          self.errorMessage=nil
          completion(true)
        }
    }
    
    func login(withEmail email:String, password:String, completion:@escaping (Bool)->(Void)) {
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                self.errorMessage = error.localizedDescription
                completion(false)
                return
            }
            self.user=result?.user
            self.errorMessage=nil
            completion(true)
        }
        
    }
    func logout() async throws {
        do {
            try  Auth.auth().signOut()
            self.user=nil
            self.errorMessage=nil
        }
        catch {
            self.errorMessage=error.localizedDescription
        }
        
    }
    
    
    func deleteUser() async throws{
        do {
            try await Auth.auth().currentUser?.delete()
            self.user=nil
            self.errorMessage=nil
        }
        catch {
            self.errorMessage=error.localizedDescription
        }
    }
}
