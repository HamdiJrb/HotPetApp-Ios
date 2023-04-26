//
//  LoginView.swift
//  Hotpet
//
//  Created by Grim on 11/3/2023.
//

import Foundation
import SwiftUI

struct RegisterNextView: View {
    
    var email: String
    var password: String
    var username: String
    
    @State private var about = ""
    @State private var birthdate = Date()
    @State private var gender = Gender.Unspecified
    @State private var category = Category.Unspecified
    
    let genders = [Gender.Unspecified, Gender.Male, Gender.Female]
    let categories = [Category.Unspecified, Category.Dog, Category.Cat, Category.Horse]
    
    @State private var selectedGender = 0
    @State private var selectedCategory = 0
    
    
    @State private var showingAlert = false
    @State private var isNavigateToLogin = false
    
    @State private var alert: Alert?
    
    var body: some View {
        ScrollView {
            VStack() {
                VStack() {
                    Image("logo_alt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 100)
                        .cornerRadius(60)
                        .shadow(radius: 5)
                    Text("Complete registration")
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Please complete your informations")
                        .fontWeight(.light)
                        .padding(.top, 10)
                }
                VStack() {
                    HStack {
                        Image(systemName: "info.circle")
                        TextField("Type things about your pet", text: $about)
                    }
                    .padding(15)
                    .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                    .shadow(color: .black, radius: 1)
                    .frame(width: 300)
                }.padding()
                VStack() {
                    Text("Birthdate")
                    VStack(alignment: .leading) {
                        DatePicker(
                            selection: $birthdate,
                            label: { /*@START_MENU_TOKEN@*/Text("Date")/*@END_MENU_TOKEN@*/ }
                        )
                            .padding(15)
                            .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                            .shadow(color: .black, radius: 1)
                            .frame(width: 300)
                    }.padding()
                }
                VStack() {
                    Text("Gender")
                    VStack(alignment: .leading) {
                        Picker("Gender", selection: $selectedGender
                        ) {
                            ForEach(0..<genders.count) { index in
                                Text("\(genders[index].description)")
                            }
                        }
                        .frame(width: 230)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .shadow(color: .black, radius: 1)
                    }.padding()
                }
                VStack() {
                    Text("Category")
                    VStack(alignment: .leading) {
                        Picker("Category", selection: $selectedCategory
                        ) {
                            ForEach(0..<categories.count) { index in
                                Text("\(categories[index].description)")
                            }
                        }
                        .frame(width: 230)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 10, tr: 10, bl: 10, br: 0))
                        .shadow(color: .black, radius: 1)
                    }.padding()
                }
                VStack {
                    Button("Register") {
                        register()
                    }
                    .alert(isPresented: $showingAlert) {
                        alert!
                    }
                    .foregroundColor(.white)
                    .padding(10)
                    .frame(width: 300)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(15)
                    .fullScreenCover(isPresented: $isNavigateToLogin, content: {
                        LoginView(initialEmail: email)
                    })
                    .labelStyle(DefaultLabelStyle())
                    .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                }.padding()
            }
            .padding()
        }
    }
    
    func register() {
        
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
        
        let user = User(
            email: email,
            password: password,
            username: username,
            birthdate: birthdate,
            gender: gender,
            category: category,
            about: about,
            images: []
        )
        
        UserViewModel.sharedInstance.register(user: user, completed: { (success, emailAlreadyExist) in
            if (success) {
                alert = AlertMaker.makeSingleActionAlert(
                    title: "Success",
                    message: "Registration is successful",
                    action: Alert.Button.default(Text("OK"), action: {
                        isNavigateToLogin = true
                    })
                )
                showingAlert = true
            } else {
                if (emailAlreadyExist) {
                    alert = AlertMaker.makeAlert(
                        title: "Error",
                        message: "Email is already taken"
                    )
                    showingAlert = true
                } else {
                    alert = AlertMaker.makeServerErrorAlert()
                    showingAlert = true
                }
            }
        })
    }
}

struct RegisterNextView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterNextView(email: "", password: "", username: "")
            .previewInterfaceOrientation(.portrait)
    }
}
