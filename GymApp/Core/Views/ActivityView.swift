//
//  ActivityView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import SwiftUI

struct ActivityView: View {
    let activity: Activity
    let isOwer: Bool
    var onDelete: (() -> Void)?
    var onEdit: (() -> Void)?
    @State var showDelete: Bool = false
    var body: some View {
        HStack {
            Text(activity.type)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text("\(activity.minutes) minutes")
                .foregroundColor(.secondary)
                .font(.caption)
                .padding(.leading, 8)
            
            
           Text("\(activity.timestamp)")
                .foregroundColor(.secondary)
                .font(.caption)
            if isOwer {
                Button(action: onEdit ?? { }) {
                    Image(systemName: "square.and.arrow.up")
                }
                .buttonStyle(PlainButtonStyle())
                Button(action: onDelete ?? { }) {
                    Image(systemName: "trash")
                        .tint(.red)
                        .confirmationDialog(
                            "Are you sure you want to delete this activity?",
                            isPresented:$showDelete,
                            titleVisibility: .visible, actions: {
                                
                            }
                        )
                }
            }
        }
    }
}

#Preview {
    ActivityView(activity: Activity(id: "1", userId: "1", userName: "1", type: "1", minutes: 1), isOwer: true)
}
