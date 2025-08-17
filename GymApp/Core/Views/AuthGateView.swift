//
//  AuthGateView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

//Pour savoir si afficher signup ou signin
import SwiftUI

struct AuthGateView: View {
    @State var isLogin: Bool = true
    var body: some View {
       VStack{
           VStack(spacing:8){
                Text("Welcome to GymApp")
                    .font(.largeTitle)
                    .padding(.top,40)
                    .foregroundStyle(.green.opacity(0.8))
                Text("GymApp is a fitness app that helps you to track your workouts and progress")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal,20)
              
            }
      
         Spacer()
          
        
           VStack(spacing:20){
               
            if isLogin{
                LoginView()
            }
            else {
                RegisterView()
            }
            Button(" \(isLogin ? "No Account? Signup" : "  Have an account Signin")") {
                withAnimation {
                    isLogin.toggle()
                }
               
            }.font(.subheadline)
            .foregroundColor(.blue)
                   
            }.frame(maxHeight: .infinity, alignment: .center)
           Spacer()
           Image(systemName: "dumbbell")
                          .resizable()
                          .scaledToFit()
                          .frame(width: 100, height: 100)
                          .foregroundStyle(.green.opacity(0.9))
                          .padding(.vertical, 20)
        }.padding()
    }
}

#Preview {
    AuthGateView()
}
