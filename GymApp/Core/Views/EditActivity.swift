//
//  EditActivity.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import SwiftUI

struct EditActivity: View {
    let activity: Activity
    var db = DataBaseService.shared
    @Environment(\.dismiss) var dismiss
    @State private var type: String = ""
    @State private var minutes: String="0"
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Type")) {
                    TextField("Type", text: $type)
                }
                Section(header: Text("Minutes")) {
                    TextField("Minutes", text: ($minutes))
                }
            }
            .navigationBarTitle("Edit Activity", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        db.updateActivity(activity: activity, minutes: Int(minutes) ?? 0, type: type)
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Cancel") {
                            dismiss()
                    }
                }
            }
        }
    }
}

//#Preview {
   // ActivityView(activity: Activity(id: "1", userId: "1", userName: "1", type: "1", minutes: 1))
//}
