//
//  RegisterView.swift
//  GymApp
//
//  Created by Fabrice Kouonang on 2025-08-16.
//

import SwiftUI

struct RegisterView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var auth=AuthService.shared
    var body: some View {
        VStack(spacing: 20) {
            Text("Register")
            TextField("Email", text: $email)
                .textInputAutocapitalization(.never)
                .textFieldStyle(.roundedBorder)
            SecureField("Password", text: $password)
                .textFieldStyle(.roundedBorder)
            Button("Sign up"){
                auth.register(withEmail: email, password:password){
                    _ in
                }
            }.buttonStyle(.borderedProminent)
            if let errorMessage = auth.errorMessage{
                Text(errorMessage).foregroundColor(.red).font(.footnote)
            }
        }
        .padding()
        .background(.thinMaterial.opacity(0.2),in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    RegisterView()
}
