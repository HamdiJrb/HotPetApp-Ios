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
                        .frame(width: 200, height: 100)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(.bottom, 30)
                        .padding(.top, 6)
                    Text("Register")
                        .font(.system(size: 35))
                        .foregroundColor(Color("SecondaryColor"))
                        .padding(.bottom, 6)
                    Text("Please type your informations")
                        .fontWeight(.light)
                        .padding(.bottom, 50)
                        
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Image(systemName: "envelope")
                            TextField("email@example.com", text: $email)
                                .font(.system(size: 16))
                        }
                        .padding(10)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .shadow(color: .black, radius: 0.7)
                        .frame(width: 250)
                        
                    }.padding(.bottom , 10)
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Type your password", text: $password)
                                .font(.system(size: 16))
                        }
                        .padding(10)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .shadow(color: .black, radius: 0.7)
                        .frame(width: 250)
                    }.padding(.bottom , 10)
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "pawprint")
                            TextField("Type your pet's username", text: $username)
                                .font(.system(size: 16))
                        }
                        .padding(10)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .shadow(color: .black, radius: 0.7)
                        .frame(width: 250)
                    }.padding(.bottom , 25)
                    VStack {
                        Button("Next") {
                            next()
                        }.alert(isPresented: $showingAlert) {
                            alert!
                        }.foregroundColor(.white)
                            .padding(10)
                            .font(.system(size: 18))
                            .frame(width: 250)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .cornerRadius(10)
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
                        Button("SIGNIN"){
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
