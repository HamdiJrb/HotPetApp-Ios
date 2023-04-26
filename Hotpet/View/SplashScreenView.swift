//
//  SplashScreenView.swift
//  Hotpet
//
//  Created by Grim on 15/4/2023.
//

import Foundation
import SwiftUI

struct SplashScreenView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false
    @State private var user = loadSession()
    @State private var shouldNavigate = false
    
    var body: some View {
        VStack {
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 250, height: 250)
                .cornerRadius(60)
                .shadow(radius: 5)
                .padding(-25)
        }
        .preferredColorScheme(isDarkMode ? .dark : .light)
        .padding()
        .navigationBarHidden(true)
        .onAppear {
            shouldNavigate = true
        }
        .fullScreenCover(isPresented: $shouldNavigate, content: {
            if user == nil {
                //LoginView(initialEmail: loadLastLoggedEmail())
                IntroView()
            } else {
                MainView()
            }
        })
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
            .previewInterfaceOrientation(.portrait)
    }
}
