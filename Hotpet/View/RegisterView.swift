//
//  LoginView.swift
//  Hotpet
//
//  Created by Grim on 11/3/2023.
//

import Foundation
import SwiftUI

struct RegisterView: View {
    
    @State private var showingAlert = false
    @State private var isNavigateToLogin = false
    @State private var isNavigateToRegisterNext = false
    
    @State private var email = ""//"snoupii@gmail.com"
    @State private var password = ""//"123456"
    @State private var username = ""//"snoupii"
    
    @State private var alert: Alert?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Image("logo_alt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 100)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    Text("Register")
                        .font(.largeTitle)
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Please type your informations")
                        .fontWeight(.light)
                        .padding(.top, 10)
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "envelope")
                            TextField("email@example.com", text: $email)
                        }
                        .padding(15)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 15, tr: 15, bl: 15, br: 0))
                        .shadow(color: .black, radius: 1)
                        .frame(width: 270)
                    }.padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Type your password", text: $password)
                        }
                        .padding(15)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 15, tr: 15, bl: 15, br: 0))
                        .shadow(color: .black, radius: 1)
                        .frame(width: 270)
                    }.padding()
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "pawprint")
                            TextField("Type your pet's username", text: $username)
                        }
                        .padding(15)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 15, tr: 15, bl: 15, br: 0))
                        .shadow(color: .black, radius: 1)
                        .frame(width: 270)
                    }.padding()
                    VStack {
                        Button("Next") {
                            next()
                        }.alert(isPresented: $showingAlert) {
                            alert!
                        }.foregroundColor(.white)
                            .padding(10)
                            .frame(width: 285)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(15)
                            .labelStyle(DefaultLabelStyle())
                            .font(.title)
                        NavigationLink(
                            destination: RegisterNextView(
                                email: email,
                                password: password,
                                username: username
                            ),
                            isActive: $isNavigateToRegisterNext
                        ){
                            EmptyView()
                        }
                    }.padding()
                    HStack{
                        Text("Already have an account ?")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                        Button("Login"){
                            isNavigateToLogin = true
                        }
                        .fullScreenCover(isPresented: $isNavigateToLogin, content: {
                            LoginView(initialEmail: email)
                        })
                    }
                    .padding(.top, 10)
                }
                .padding()
            }
            .navigationBarHidden(true)
        }
    }
    
    func next() {
        
        if(email.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Please type your email"
            )
            showingAlert = true
            return
        }
        
        if !(email.contains("@")){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Please type your email correctly"
            )
            showingAlert = true
            return
        }
        
        if (password.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Password can't be empty"
            )
            showingAlert = true
            return
        }
        
        if (username.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Username can't be empty"
            )
            showingAlert = true
            return
        }
        
        isNavigateToRegisterNext = true
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            RegisterView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
