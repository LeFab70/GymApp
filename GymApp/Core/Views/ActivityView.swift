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
    var onEdit: ((Activity) -> Void)?
    @State var showDeleteConfirm: Bool = false
    var body: some View {
        HStack {
            VStack{
                HStack{
                    iconActivity
                    VStack(alignment: .leading, spacing: 5) {
                            activityDescription
                            activityDuration
                   
                        }
                }
                HStack{
                    Spacer()
                    actionsButton
                }
            }
        }
    }
    
    var iconActivity: some View {
        Circle()
            .fill(.green.gradient)
            .frame(width: 35, height: 35)
            .overlay(
                Image(systemName: "figure.run")
                    .font(.title)
                    .foregroundColor(.white)
            )
    }
    
    var activityDescription: some View {
        HStack{Text(activity.type)
                .font(.headline)
                .foregroundColor(.primary)
            Spacer()
            Text(Date(timeIntervalSince1970: activity.timestamp), format: .dateTime.day().month().year().hour().minute())
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
    
    var activityDuration: some View {
        Group {
            Text("\(activity.minutes) minutes")
                .foregroundColor(.secondary)
                .font(.subheadline)
               
            Text(activity.userName)
                .foregroundColor(.secondary)
                .font(.caption)
        }
    }
  
    var editButton: some View {
        Button {
            // onEdit
            onEdit?(activity)
        } label: {
            Image(systemName: "pencil")
        }
        .font(.title3)
    }

    var deleteButton: some View {
        Button {
           
            showDeleteConfirm = true
        } label: {
            Image(systemName: "trash")
                .tint(.red)
         
        }
        .font(.title3)
        .confirmationDialog(
            "Are you sure you want to delete this activity?",
            isPresented: $showDeleteConfirm,
            titleVisibility: .visible, actions: {
                Button("Delete", role: .destructive) {
                    // onDelete
                    onDelete?() // fera appel a la fun definie lors de appel de activityView
                }
                Button("Cancel", role: .cancel) {} //no action just toogle showDeleteConfirm which is binding
            }
        )
    }

    var actionsButton: some View {
       Group {
            if isOwer {
                HStack {
                    editButton
                    deleteButton
                }
            }
        }
    }
       
    
}

#Preview {
    ActivityView(activity: Activity(id: "1", userId: "1", userName: "1", type: "1", minutes: 1), isOwer: true, onDelete: nil, onEdit: nil)
}
