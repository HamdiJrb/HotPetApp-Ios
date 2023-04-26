//
//  Like.swift
//  Hotpet
//
//  Created by Grim on 12/4/2023.
//

import Foundation

struct Like: Codable, Identifiable {
    var id: UUID?
    
    var _id: String? = nil
    var liked: User?
    var liker: User?
    var isRight: Bool
    var isMatch: Bool
}
