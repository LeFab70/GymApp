//
//  ContentView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import SwiftUI

struct GymView: View {
    
@State private var auth=AuthService.shared
    var body: some View {
       Group
        {
            if let user = auth.user
            {
                HomeView(currentUser: user)
                
            }
            else {
                AuthGateView()
            }
        }
       
    }
}

#Preview {
    GymView()
}
