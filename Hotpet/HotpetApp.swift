//
//  HotpetApp.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI
import GoogleSignIn
import StripeCore

@main
struct HotpetApp: App {
    
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
                .onOpenURL { url in
                    GIDSignIn.sharedInstance.handle(url)
                }
        }
    }
}
