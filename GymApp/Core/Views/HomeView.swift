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
    @State private var selectedImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var isLoading: Bool = false
    @State private var updateStatus: String?
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
                .textFieldStyle(.roundedBorder) //prendre ceci  comme description
            
            TextField("Minutes", text: $newMinite)
                .keyboardType(.numberPad)
                .textFieldStyle(.roundedBorder)
                .frame(width: 100)
                .onChange(of: newMinite) {
                    newMinite = newMinite.filter { ("0"..."9").contains($0) }
                }
            HStack(alignment: .center, spacing: 15) {
                buttonAddImageView
                Spacer()
                if let selectedImage = selectedImage {
                    Circle()
                        .fill(.green.gradient.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .overlay(
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(Circle())
                        )
                }
            }
            if isLoading {
                ProgressView()
            }
            Button{
                addActivity()
            }
            label: {
                HStack {
                    Image(systemName: "plus.circle.fill")
                        .font(.title2)
                        .foregroundStyle(.white)
                    Text("Add an activity")
                }
                
            }.buttonStyle(.borderedProminent)
            
            
        }.padding(.horizontal)
    }
    
    
    var buttonAddImageView : some View {
        Button(action: {showImagePicker = true})
        {
            Label("Pick Image", systemImage: "arrow.up.circle.fill")
                .font(.headline)
                .padding(10)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.green, Color.mint]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            
        }
        .sheet(isPresented:$showImagePicker){
            CameraViewController(capturedImage: $selectedImage)
        }
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
        if !newType.isEmpty && !newMinite.isEmpty && selectedImage != nil{
            if let user=currentUser{
                //db.addActivity(type: newType, minutes: Int(newMinite) ?? 0, user: user)
                guard let minite=Int(newMinite),minite>0 else {return}
                isLoading=true
                //uploadImage() //charger image dans storage fait
               // lors de la save activity
                //save activitye avec image liée
                db.addActivity(type: newType, minutes: minite, user: user,image: selectedImage,description: newType)
                isLoading = false
                newType=""
                newMinite=""
                selectedImage=nil
                isLoading=false
            }
        }
    }
    
    
//    func uploadImage() {
//        guard let selectedImage = selectedImage else {
//            return
//        }
//        isLoading = true
//        db.uploadImage(image: selectedImage,description: newType) { result in
//            isLoading = false
//            switch result {
//            case .success:
//                updateStatus = "Updated successfully"
//            case .failure(let error):
//                updateStatus = error.localizedDescription
//            }
//        }
//    }
    
}

#Preview {
   HomeView(currentUser: nil)
}
