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
    @State private var selectedTab = 0
    var body: some View {
        NavigationView {
            VStack(){
                TabView(selection: $selectedTab) {
                   
                    Tab("Add Activity", systemImage: "plus.circle.fill", value: 0) {
                        tabViewAddActivity
                    }
                    Tab("Ranking",systemImage: "list.bullet", value: 1){
                        RankingView()
                        ChartViewRanking()
                    }
                    .badge(db.ranking.count)
                    
                   
                    Tab("Actitivies",systemImage: "list.bullet.rectangle", value: 2){
                        //affichage
                        if db.activities.isEmpty{
                            listActivityEmpyView
                        }
                        else{
                            //listActivityEmpyView
                            listActivityView
                        }
                    }
                    .badge(db.activities.count)
                    
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
    
    var tabViewAddActivity: some View {
            VStack(spacing: 20) {
                welcomeUser
                addActivityView
            }
            .padding(.horizontal)
            .padding(.top, 5)
    }

    
    
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
        VStack(alignment: .leading, spacing: 30){
            HStack(alignment: .center,spacing: 20){
               Text("Add an activity")
                   .font(.title)
                   .fontWeight(.bold)
                   .foregroundColor(.green.opacity(0.8))
                   .padding(.bottom, 5)
                   
                Image(systemName: "plus.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.green.opacity(0.8))
            }
            
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
                    .swipeActions(edge: .trailing) {
                        if activity.userId == currentUser?.uid {
                                            Button {
                                                self.editActivity = activity
                                            } label: {
                                                Label("Éditer", systemImage: "pencil")
                                            }
                                            .tint(.orange)

                                            Button(role: .destructive) {
                                                db.deleteActivity(activity: activity)
                                            } label: {
                                                Label("Supprimer", systemImage: "trash")
                                            }
                                        }
                    }
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
