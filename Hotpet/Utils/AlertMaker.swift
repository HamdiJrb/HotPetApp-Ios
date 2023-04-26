//
//  AlertMaker.swift
//  Hotpet
//
//  Created by Grim on 11/3/2023.
//

import Foundation
import SwiftUI

public class AlertMaker {
    static func makeAlert(title: String, message: String) -> Alert {
        return Alert(title: Text(title), message: Text(message), dismissButton: .cancel(Text("Ok")))
    }
    
    static func makeActionAlert(title: String, message: String, action: Alert.Button) -> Alert {
        return Alert(title: Text(title), message: Text(message), primaryButton: action, secondaryButton: .cancel())
    }
    
    static func makeSingleActionAlert(title: String, message: String, action: Alert.Button) -> Alert {
        return Alert(title: Text(title), message: Text(message), dismissButton: action)
    }
    
    static func makeServerErrorAlert() -> Alert {
        return Alert(title: Text("Error"), message: Text("Internal server error"), dismissButton: .cancel(Text("Ok")))
    }
}
