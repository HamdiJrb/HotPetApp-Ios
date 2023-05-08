//
//  User.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID?
    
    
    var _id: String? = nil
    var email: String
    var password: String
    var username: String
    var birthdate: Date
    var gender: Gender
    var category: Category
    var about: String
    
    // PREFERENCES
    var preferredAgeMin: Int?
    var preferredAgeMax: Int?
    var preferredDistance: Int?
    
    // LOCATION
    var latitude: Double?
    var longitude: Double?
    
    // OTHERS
    var imageFilename: String?
    var images: [String]
    var isVerified: Bool?
}

enum Gender: Codable {
    case Male
    case Female
    case Unspecified
    
    var description : String {
      switch self {
      case .Male: return "Male"
      case .Female: return "Female"
      case .Unspecified: return "Unspecified"
      }
    }
}

enum UserRole {
    case regular
    case premium
}

enum Category: Codable {
    case Cat
    case Dog
    case Horse
    case Unspecified
    
    var description : String {
      switch self {
      case .Cat: return "Cat"
      case .Dog: return "Dog"
      case .Horse: return "Horse"
      case .Unspecified: return "Unspecified"
      }
    }
}
