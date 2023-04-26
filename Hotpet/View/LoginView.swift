//
//  LoginView.swift
//  Hotpet
//
//  Created by Grim on 11/3/2023.
//

import Foundation
import SwiftUI
import FBSDKLoginKit
import FacebookLogin
import GoogleSignInSwift
import GoogleSignIn

struct LoginView: View {
    
    var initialEmail: String
    
    let loginManager = LoginManager()
    let permissions = ["user_birthday", "user_gender", "public_profile"]
    
    @State private var showingAlert = false
    @State private var isNextPageActive = false
    @State private var isNavigateToSignup = false
    
    //@State private var email = "snoupi@gmail.com"
    //@State private var password = "123456"
    
    @State private var email = ""
    @State private var password = ""
    
    @State private var alert: Alert?
    
    var body: some View {
        
        NavigationView {
            ScrollView {
                VStack {
                    Image("logo_alt")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 250, height: 250)
                        .cornerRadius(60)
                        .shadow(radius: 5)
                        .padding(-25)
                    Text("Sign in")
                        .font(/*@START_MENU_TOKEN@*/.largeTitle/*@END_MENU_TOKEN@*/)
                        .foregroundColor(Color("SecondaryColor"))
                    Text("Please login to your account")
                        .fontWeight(.light)
                        .padding(.top,-8)
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "envelope")
                            TextField("Exp: email@example.com", text: $email)
                                .frame(width: 250)
                        }
                        .padding(11)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 15, tr: 15, bl: 15, br: 0))
                        .shadow(color: .black, radius: 1)
                    }.padding(1)
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "lock")
                            SecureField("Type your password", text: $password)
                                .frame(width: 250)
                        }
                        .padding(12)
                        .background(CustomRoundedCorners(color: Color("BackgroundSecondary"), tl: 15, tr: 15, bl: 15, br: 0))
                        .shadow(color: .black, radius: 1)
                    }.padding(20)
                    VStack {
                        Button("Sign In") {
                            login(email: email, password: password)
                        }
                        .alert(isPresented: $showingAlert) {
                            alert!
                        }
                        //.frame(maxWidth: .infinity)
                        .frame(width: 285)
                        .padding(10)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(15)
                        .foregroundColor(.white)
                        .fullScreenCover(isPresented: $isNextPageActive, content: {
                            MainView()
                        })
                        .labelStyle(DefaultLabelStyle())
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                    }.padding()
                    HStack{
                        Text("You don't have an account ?")
                            .fontWeight(.bold)
                            .foregroundColor(Color.black)
                        
                        Button("SIGN UP"){
                            isNavigateToSignup = true
                        }
                        .fullScreenCover(isPresented: $isNavigateToSignup, content: {
                            RegisterView()
                        })
                    }
                    .padding(.top, 30)
                    /*Spacer(minLength: 20)
                    GoogleSignInButton(action: handleSignInButton)
                    Button(action: {
                        facebookLogin()
                    }) {
                        Text("Continue with Facebook")
                            .frame(minWidth: 200, maxWidth: .infinity)
                            .padding(10)
                            .foregroundColor(.white)
                            .background(Color("FacebookColor"))
                            .cornerRadius(5)
                    }*/
                }
                .padding()
                .navigationBarHidden(true)
            }
        }
        .onAppear {
            email = initialEmail
        }
    }
    
    func login(email:String, password:String) {
        if(email.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Email should not be empty"
            )
            showingAlert = true
            return
        }
        
        if(password.isEmpty){
            alert = AlertMaker.makeAlert(
                title: "Warning",
                message: "Password should not be empty"
            )
            showingAlert = true
            return
        }
        
        
        UserViewModel.sharedInstance.login(email: email, password: password, completed: { (success, isInvalid, isNotVerified, reponse) in
            
            if success {
                isNextPageActive = true
            } else {
                if isInvalid {
                    alert = AlertMaker.makeAlert(
                        title: "Warning",
                        message: "Email or password incorrect"
                    )
                    showingAlert = true
                } else {
                    if isNotVerified {
                        alert = AlertMaker.makeAlert(
                            title: "Warning",
                            message: "Email not verified"
                        )
                        showingAlert = true
                    } else {
                        alert = AlertMaker.makeServerErrorAlert()
                        showingAlert = true
                    }
                }
            }
        })
    }
    
    /*func handleSignInButton() {
        guard let presentingViewController = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {return}
        
        GIDSignIn.sharedInstance.signIn(
            withPresenting: presentingViewController) { signInResult, error in
                guard let result = signInResult else {
                    // Inspect error
                    return
                }
                print(result.user.profile!.email)
                UserViewModel.sharedInstance.loginWithSocial(email: result.user.profile!.email) { success, user in
                    if success {
                        isNextPageActive = true
                    } else {
                        alert = AlertMaker.makeServerErrorAlert()
                        showingAlert = true
                    }
                }
            }
    }
    
    func facebookLogin() {
        loginManager.logIn(permissions: permissions, from: nil) { loginResult, error in
            GraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    let fbDetails = result as! NSDictionary
                    print(fbDetails["email"] as! String)
                    UserViewModel.sharedInstance.loginWithSocial(email: fbDetails["email"] as! String) { success, user in
                        if success {
                            isNextPageActive = true
                        } else {
                            alert = AlertMaker.makeServerErrorAlert()
                            showingAlert = true
                        }
                    }
                }
            })
        }
    }*/
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(initialEmail: "snoupi@gmail.com")
            .previewInterfaceOrientation(.portrait)
    }
}
