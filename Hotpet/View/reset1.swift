//
//  Reset1.swift
//  Hotpet
//
//  Created by Hamdi on 5/5/2023.
//

import Foundation
import SwiftUI
import Alamofire
import SwiftyJSON

struct Reset1View: View {
    @State private var email: String = ""
    @State private var isLoading = false
    @ObservedObject var viewModel = UserViewModel()
    @State private var showError = false
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var token: String?
    @State private var isReset2Active = false
    @State private var isPresentingReset2 = false
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                Image("reset1")
                    .resizable()
                    .frame(width: 200, height: 200 , alignment: .center)
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                
                Text("Forgot Password?")
                    .font(Font.system(size: 25))
                    .bold()
                
                Text("We've got you covered.")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top,10)
                
                TextField("Email", text: $email)
                    .frame(width: 250, height: 50)
                    .foregroundColor(.black)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 15))
                    .textFieldStyle(PlainTextFieldStyle())
                    .background(Color(.systemGray6).opacity(0.7))
                    .cornerRadius(30)
                    .padding(.horizontal,20)
                    .padding(.top,30)
                
                Button(
                    action: {
                        // Perform send reset password email action
                        withAnimation {
                            isLoading = true
                            viewModel.sendResetPassword(email: email, completed: { success, message in
                                isLoading = false
                                if success {
                                    token = message
                                    isReset2Active = true // Activate NavigationLink to navigate to Reset2View
                                } else {
                                    showError = true
                                    errorTitle = "Error"
                                    errorMessage = message ?? "Unknown error occurred."
                                }
                                print("token after completion: \(token ?? "none")")
                            })
                        }
                    }) {
                        if isLoading {
                            ProgressView()
                                .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                                .scaleEffect(2)
                                .padding()
                        } else {
                            Text("Send")
                                .padding(.horizontal,110)
                                .foregroundColor(.white)
                                .padding()
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(30)
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 40)
                
                
                Spacer()
            }
            .alert(isPresented: $showError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
            .background(
                NavigationLink(
                    destination: Reset2View(token: token ?? "", email: email),
                    isActive: $isReset2Active
                ) { EmptyView() }
                    .hidden()
            )
            .navigationBarHidden(true)
        }
    }
    
    struct Reset1_Previews: PreviewProvider {
        static var previews: some View {
            Reset1View()
        }
    }
}
