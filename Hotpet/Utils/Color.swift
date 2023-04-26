//
//  Color.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI

extension Color {
    //trgtrg
    static let electricPink = Color(UIColor(red: 253/255, green: 17/255, blue: 115/255, alpha: 1.0))
    static let gold = Color(UIColor(red: 254/255, green: 129/255, blue: 35/255, alpha: 1.0))
    
    public static var random: Color {
        return Color(UIColor(red: CGFloat(drand48()),
                             green: CGFloat(drand48()),
                             blue: CGFloat(drand48()), alpha: 1.0))
    }
}
