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
    @State private var db=DataBaseService.shared
    let currentUser:FirebaseAuth.User?
    @State private var newType:String=""
    @State private var newMinite:String=""
    @State private var editActivity:Activity?
    var body: some View {
        NavigationStack {
            VStack{
                VStack(spacing:20){
                    welcomeUser
                    addActivityView
                }.padding(.horizontal)
                    .padding(.top,5)
                
                //affichage
                if db.activities.isEmpty{
                    listActivityEmpyView
                }
                else{
                    //listActivityEmpyView
                    listActivityView
                }
            }
            .navigationTitle(
                Text("Gym App")
           )
            .toolbar{
              toolBarItemLogOut
            }
            .sheet(item: $editActivity, content: { activity in
                if let index = db.activities.firstIndex(where: { $0.id == activity.id }) {
                    EditActivityView(activity: $db.activities[index])
                }
            })
        }
        .padding(.top)
        
       
    }
    
    //variable pour reduire le content de body
    var toolBarItemLogOut : some ToolbarContent {
        ToolbarItem(placement: .navigationBarTrailing){
            Button(action: {
                Task{
                    try? await auth.logout()
                }
            }){
                Image(systemName:"power.circle.fill")
                    .foregroundStyle(.green.opacity(0.4))
                    .font(.system(size: 30))
            }
        }
    }
    
    var welcomeUser : some View {
            Text(currentUser?.email != nil
                 ? "Welcome \(currentUser?.email ?? "")"
                 : "Please login")
    }
    
    var addActivityView : some View {
        HStack{
            TextField("Type", text: $newType)
                .textFieldStyle(.roundedBorder)
            TextField("Minutes", text: $newMinite)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
                .onChange(of: newMinite) {
                    newMinite = newMinite.filter { ("0"..."9").contains($0) }
                }
            Button{
               addActivity()
            }
          label: {
                Image(systemName: "plus.circle.fill")
                  .font(.title2)
                        .foregroundStyle(.white)
          }.buttonStyle(.borderedProminent)
                
        }.padding(.horizontal)
    }
    
    
    var listActivityView : some View {
        //isOwer  permet de display ou non les buttons delete et edit selon a qui apprtient l'activity
        List{
            ForEach(db.activities){activity in
                HStack{
                    
                    ActivityView(activity: activity, isOwer: activity.userId==currentUser?.uid, onDelete: {
                        db.deleteActivity( activity: activity)
                    }, onEdit: {_ in self.editActivity = activity})
                }
            }.listStyle(.plain)
            .listItemTint(Color.clear)
        }
    }
    
    var listActivityEmpyView: some View {
        ContentUnavailableView("No activity yet",systemImage: "figure.run", description:Text("Add your first activity")).frame(maxWidth: .infinity, maxHeight: .infinity)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.secondary,.green)
            .font(.title)
    }
    
    //functions
    func addActivity(){
        if !newType.isEmpty && !newMinite.isEmpty{
            if let user=currentUser{
                //db.addActivity(type: newType, minutes: Int(newMinite) ?? 0, user: user)
                guard let minite=Int(newMinite),minite>0 else {return}
                db.addActivity(type: newType, minutes: minite, user: user)
                newType=""
                newMinite=""
            }
            }
    }
    
}

#Preview {
   HomeView(currentUser: nil)
}
