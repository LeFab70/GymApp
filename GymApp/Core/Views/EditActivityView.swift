//
//  EditActivityView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-17.
//

import SwiftUI

struct EditActivityView: View {
    @Binding  var activity: Activity
    @State private var db=DataBaseService.shared
    @State private var newType: String = ""
    @State private var newMinutes: String = ""
    @Environment(\.dismiss) var dismiss
    var body: some View {
        NavigationStack {
            VStack{
                editActivityView
                Spacer()
            }.padding()
                .onAppear {
                    // Initialisez les champs de texte avec les valeurs actuelles de l'activité
                    newType = activity.type
                    newMinutes = String(activity.minutes)
                }
                .navigationTitle("Edit activity")
                .toolbar{
                   editActivityToolbar
                   cancelToolbar
                }
        }
    }
    
    
    var cancelToolbar : some ToolbarContent {
        ToolbarItem(placement: .cancellationAction){
            Button("Cancel"){
                dismiss()
            }
        }
    }
    
     var editActivityToolbar : some ToolbarContent {
         ToolbarItem(placement: .confirmationAction){
             Button("Save"){
                 editActivity()
                 dismiss()
             }
         }
    }
    var editActivityView : some View {
        Form{
            Section(header: Text("Activity")){
                TextField("Type", text: $newType)
                    .textFieldStyle(.roundedBorder)
                TextField("Minutes", text: $newMinutes)
                    .keyboardType(.numberPad)
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .onChange(of: newMinutes) {
                        newMinutes = newMinutes.filter { ("0"..."9").contains($0) }
                    }
                Button{
                   editActivity()
                    dismiss()
                }
              label: {
                    Image(systemName: "pencil.circle.fill")
                      .font(.title2)
                            .foregroundStyle(.white)
              }.buttonStyle(.borderedProminent)
            }
          
          
                
        }.padding(.horizontal)
    }
    func editActivity(){
        db.updateActivity(activity: activity, minutes: Int(newMinutes) ?? 0, type: newType)
    }
}

#Preview {
    struct PreviewWrapper: View {
            @State private var activity = Activity(id: "1", userId: "1", userName: "1", type: "course", minutes: 30)
            
            var body: some View {
                EditActivityView(activity: $activity)
            }
        }
        return PreviewWrapper()
}
