//
//  EditProfileView.swift
//  Hotpet
//
//  Created by Grim on 11/3/2023.
//

import Foundation
import SwiftUI

struct EditProfileView: View {
    
    @Environment(\.presentationMode) var presentationMode
    @Binding var shouldRefresh: Bool
    
    var user = loadSession()!
    
    @State private var email = ""//"snoupii@gmail.com"
    @State private var username = ""//"snoupii"
    @State private var about = ""
    @State private var birthdate = Date()
    @State private var gender = Gender.Unspecified
    @State private var category = Category.Unspecified
    
    let genders = [Gender.Unspecified, Gender.Male, Gender.Female]
    let categories = [Category.Unspecified, Category.Dog, Category.Cat, Category.Horse]
    
    
    @State private var selectedGender = 0
    @State private var selectedCategory = 0
    
    @State private var showingAlert = false
    @State private var alert: Alert?
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    Text("Update your profile details")
                        .font(.system(size: 24) .weight(.medium))
                        .foregroundColor(Color("SecondaryColor"))
                        .padding(.bottom, 20)
                    /*VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "envelope")
                            TextField("Exp: email@example.com", text: $email)
                        }
                        .padding(15)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .shadow(color: .black, radius: 1)
                    }*/
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "pawprint")
                            TextField("Edit your pet's username", text: $username)
                        }
                        .font(.system(size: 16))
                        .padding(10)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .frame(width: 250)
                    }
                    .padding(.bottom, 6)
                    VStack() {
                        HStack {
                            Image(systemName: "info.circle")
                            TextField("Type things about your pet", text: $about)
                        }
                        .font(.system(size: 16))
                        .padding(10)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .frame(width: 250)
                    }
                    .padding(.bottom, 15)
                    VStack() {
                        Text("Birthdate")
                        VStack(alignment: .leading) {
                            DatePicker(
                                selection: $birthdate,
                                label: { Text("") }
                            )
                            .font(.system(size: 15))
                                .padding(15)
                                .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                                .frame(width: 250)
                        }
                        .padding(.bottom, 30)
                    }
                    /*VStack() {
                        Text("Gender")
                        VStack(alignment: .leading) {
                            Picker("Gender", selection: $selectedGender
                            ) {
                                ForEach(0..<genders.count) { index in
                                    Text("\(genders[index].description)")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                            .shadow(color: .black, radius: 1)
                        }.padding()
                    }*/
                    /*VStack() {
                        Text("Category")
                        VStack(alignment: .leading) {
                            Picker("Category", selection: $selectedCategory
                            ) {
                                ForEach(0..<categories.count) { index in
                                    Text("\(categories[index].description)")
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                            .shadow(color: .black, radius: 1)
                        }.padding()
                    }*/
                    VStack {
                        Button("Edit profile") {
                            editProfile()
                        }
                        .alert(isPresented: $showingAlert) {
                            alert!
                        }
                        .foregroundColor(.white)
                        .padding(10)
                        .font(.system(size: 20))
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
                    }.padding()
                }
                .padding()
            }
            .navigationBarHidden(true)
            .onAppear {
                email = user.email
                username = user.username
                about = user.about
                birthdate = user.birthdate
                
                if user.gender == Gender.Male {
                    selectedGender = 1
                } else if user.gender == Gender.Female {
                    selectedGender = 2
                } else {
                    selectedGender = 0
                }
                
                if user.category == Category.Dog {
                    selectedCategory = 1
                } else if user.category == Category.Cat {
                    selectedCategory = 2
                } else if user.category == Category.Horse {
                    selectedCategory = 3
                } else {
                    selectedCategory = 0
                }
            }
        }
    }
    
    func editProfile() {
        
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
        
        
        if (username.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Username can't be empty"
            )
            showingAlert = true
            return
        }
        
        if(about.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "About should not be empty"
            )
            showingAlert = true
            return
        }
        
        if(selectedGender == 0){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "You should specify the gender"
            )
            showingAlert = true
            return
        }
        
        if(selectedCategory == 0){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "You should specify the category"
            )
            showingAlert = true
            return
        }
        
        gender = genders[selectedGender]
        category = categories[selectedCategory]
        
        var savedUser: User = user;
        
        savedUser.email = email
        savedUser.username = username
        savedUser.birthdate = birthdate
        savedUser.gender = gender
        savedUser.category = category
        savedUser.about = about
        
        UserViewModel.sharedInstance.updateProfile(user: savedUser) { sucess  in
            if sucess {
                saveSession(user: savedUser)
                shouldRefresh = true
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EditProfileView(shouldRefresh: .constant(false))
                .previewInterfaceOrientation(.portrait)
        }
    }
}
