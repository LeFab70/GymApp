//
//  HomeView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import SwiftUI
import FirebaseAuth
struct HomeView: View {
    @State private var auth=AuthService.shared
    let currentUser:User
    @State private var newType:String=""
    @State private var newMinite:String=""
    @State private var db=DataBaseService.shared
    @State private var editActivity:Activity?
    var body: some View {
        VStack{
        VStack{
            Text("Welcome \(currentUser.email ?? "")")
            Spacer()
            HStack{
                TextField("Activities (e.g Run)",text: $newType)
                    .textFieldStyle(.roundedBorder)
                TextField("Minutes",text: $newMinite)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 120)
                Button{
                    db.addActivity(type: newType, minutes: Int(newMinite) ?? 0, user: currentUser)
                }
                label:{
                    Image(systemName: "plus")
                }
                
            }
            
            Button("sign out"){
                Task{
                    try? await auth.logout()
                }
            }
        }
            //affichage
            if db.activities.isEmpty{
                ContentUnavailableView("No activity yet",systemImage: "figure.meditative", description:Text("Add your first activity")).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            else{
                List{
                    ForEach(db.activities){activity in
                        HStack{
                            ActivityView(activity: activity, isOwer: activity.userId==currentUser.uid, onDelete: {
                                db.deleteActivity( activity: activity)
                                
                            }, onEdit: {editActivity=activity}, showDelete: true)
                            
                        }
                    }.listStyle(.plain)
                }
            }
    }
    }
}

//#Preview {
   //HomeView(currentUser: nil)
//}
