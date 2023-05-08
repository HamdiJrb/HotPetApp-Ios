//
//  UserViewModel.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import Foundation
import Alamofire
import SwiftyJSON

class UserViewModel: ObservableObject {
    
    static let sharedInstance = UserViewModel()
    
    func getOne(_id: String, completed: @escaping (Bool, User?) -> Void) {
        AF.request(BASE_URL + "user/one/"+_id,
                   method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let user = self.makeItem(jsonItem: JSON(response.data!))
                    saveSession(user: user)
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getAll(completed: @escaping (Bool, [User]?) -> Void) {
        AF.request(BASE_URL + "user", method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { [self] response in
                switch response.result {
                case .success:
                    var users: [User] = []
                    for singleJsonItem in JSON(response.data!) {
                        users.append(self.makeItem(jsonItem: singleJsonItem.1))
                    }
                    completed(true, users)
                case let .failure(error):
                    completed(false, nil)
                    debugPrint(error)
                }
            }
    }
    
    
    func login(email: String, password: String, completed: @escaping (Bool, Bool, Bool, Any?) -> Void) {
        AF.request(BASE_URL + "user/login",
                   method: .post,
                   parameters: ["email": email.replacingOccurrences(of: " ", with: "").lowercased(), "password": password])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let user = self.makeItem(jsonItem: JSON(response.data!))
                    saveSession(user: user)
                    completed(true, true, true, user)
                case let .failure(error):
                    debugPrint(error)
                    if (response.response?.statusCode == 403) {
                        completed(false, true, true,  nil)
                    } else if (response.response?.statusCode == 402) {
                        completed(false, false, true, nil)
                    } else {
                        completed(false, false, false, nil)
                    }
                }
            }
    }
    
    func loginWithSocial(email: String, completed: @escaping (Bool, Any?) -> Void) {
        AF.request(BASE_URL + "user/login-with-social",
                   method: .post,
                   parameters: ["email": email.replacingOccurrences(of: " ", with: "").lowercased()])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let user = self.makeItem(jsonItem: JSON(response.data!))
                    saveSession(user: user)
                    completed(true, user)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func register(user: User, completed: @escaping (Bool, Bool) -> Void) {
        AF.request(BASE_URL + "user/register",
                   method: .post,
                   parameters: [
                    "email": user.email.replacingOccurrences(of: " ", with: "").lowercased(),
                    "password": user.password,
                    "username": user.username,
                    "birthdate": DateUtils.formatFromDate(date: user.birthdate),
                    "gender": user.gender,
                    "category": user.category,
                    "about": user.about
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, true)
                case let .failure(error):
                    debugPrint(error)
                    if (response.response?.statusCode == 403) {
                        completed(false, true)
                    } else {
                        completed(false, false)
                    }
                }
            }
    }
    
    func updateProfile(user: User, completed: @escaping (Bool) -> Void) {
        AF.request(BASE_URL + "user/update-profile",
                   method: .put,
                   parameters: [
                    "email": user.email.replacingOccurrences(of: " ", with: "").lowercased(),
                    "username": user.username,
                    "birthdate": DateUtils.formatFromDate(date: user.birthdate),
                    "gender": user.gender,
                    "category": user.category,
                    "about": user.about
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func updateProfileImage(email: String, imageFilename: String, completed: @escaping (Bool) -> Void) {
        AF.request(BASE_URL + "user/update-profile-image",
                   method: .put,
                   parameters: [
                    "email": email.replacingOccurrences(of: " ", with: "").lowercased(),
                    "imageFilename": imageFilename
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func addImage(email: String, imageUrl: URL, completed: @escaping (Bool) -> Void) {
        AF.upload(multipartFormData: { multipartFormData in
            
            do {
                let data = try Data(contentsOf: imageUrl, options: .mappedIfSafe)
                
                multipartFormData.append(data, withName: "image" , fileName: "image.jpg", mimeType: "video/mp4")
            } catch  {
            }
            
            for (key, value) in
                    [
                        "email": email.replacingOccurrences(of: " ", with: "").lowercased()
                    ]
            {
                multipartFormData.append((value.data(using: .utf8))!, withName: key)
            }
            
        },to: BASE_URL + "user/add-image",
                  method: .put)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    print("Success")
                    completed(true)
                case let .failure(error):
                    completed(false)
                    print(error)
                }
            }
    }
    
    func deleteImage(email: String, imageFilename: String, completed: @escaping (Bool, Bool) -> Void) {
        AF.request(BASE_URL + "user/delete-image",
                   method: .put,
                   parameters: [
                    "email": email.replacingOccurrences(of: " ", with: "").lowercased(),
                    "imageFilename": imageFilename
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, true)
                case let .failure(error):
                    debugPrint(error)
                    if (response.response?.statusCode == 403) {
                        completed(false, true)
                    } else {
                        completed(false, false)
                    }
                }
            }
    }
    
    func updatePreferredParams(email: String, preferredAgeMin: Int, preferredAgeMax: Int, preferredDistance: Int, completed: @escaping (Bool) -> Void) {
        AF.request(BASE_URL + "user/update-preferred-params",
                   method: .put,
                   parameters: [
                    "email": email.replacingOccurrences(of: " ", with: "").lowercased(),
                    "preferredAgeMin": preferredAgeMin,
                    "preferredAgeMax": preferredAgeMax,
                    "preferredDistance": preferredDistance
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func updateLocation(email: String, latitude: Double, longitude: Double, completed: @escaping (Bool) -> Void) {
        AF.request(BASE_URL + "user/update-location",
                   method: .put,
                   parameters: [
                    "email": email.replacingOccurrences(of: " ", with: "").lowercased(),
                    "latitude": latitude,
                    "longitude": longitude
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    
    func makeItem(jsonItem: JSON) -> User {
        
        let gender: Gender?
        switch jsonItem["gender"].stringValue {
        case "Male":
            gender = Gender.Male
        case "Female":
            gender = Gender.Female
        default:
            gender = Gender.Unspecified
        }
        
        let category: Category?
        switch jsonItem["category"].stringValue {
        case "Cat":
            category = Category.Cat
        case "Dog":
            category = Category.Dog
        case "Horse":
            category = Category.Horse
        default:
            category = Category.Unspecified
        }
        
        var images: [String] = []
        for singleJsonItem in jsonItem["images"] {
            images.append(singleJsonItem.1.stringValue)
        }
        
        return User(
            _id: jsonItem["_id"].stringValue,
            email: jsonItem["email"].stringValue,
            password: jsonItem["password"].stringValue,
            username: jsonItem["username"].stringValue,
            birthdate: DateUtils.formatFromString(string: jsonItem["birthdate"].stringValue),
            gender: gender!,
            category: category!,
            about: jsonItem["about"].stringValue,
            preferredAgeMin: jsonItem["preferredAgeMin"].intValue,
            preferredAgeMax: jsonItem["preferredAgeMax"].intValue,
            preferredDistance: jsonItem["preferredDistance"].intValue,
            latitude: jsonItem["latitude"].doubleValue,
            longitude: jsonItem["longitude"].doubleValue,
            imageFilename: jsonItem["imageFilename"].stringValue,
            images: images,
            isVerified: jsonItem["isVerified"].boolValue
        )
    }
    
    func sendResetPassword(email: String, completed: @escaping (Bool, String?) -> Void) {
            AF.request(BASE_URL + "user/forgot-password",
                       method: .post,
                       parameters: ["email": email.replacingOccurrences(of: " ", with: "").lowercased()])
                .validate(statusCode: 200..<300)
                .validate(contentType: ["application/json"])
                .responseData { response in
                    switch response.result {
                    case .success:
                        let jsonResponse = JSON(response.data!)
                        let message = jsonResponse["message"].stringValue
                        completed(true, message)
                    case let .failure(error):
                        debugPrint(error)
                        completed(false, nil)
                    }
                }
        }
    
    func verifyResetCode(typedResetCode: String, token: String, completed: @escaping (Bool) -> Void) {
        AF.request(BASE_URL + "user/verify-reset-code",
                   method: .post,
                   parameters: ["typedResetCode": typedResetCode, "token": token])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }
    
    func updatePassword(email: String, password: String, completed: @escaping (Bool) -> Void) {
        let parameters = ["email": email, "password": password]
        AF.request(BASE_URL + "user/update-password",
                   method: .put,
                   parameters: parameters)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true)
                case let .failure(error):
                    debugPrint(error)
                    completed(false)
                }
            }
    }




}
