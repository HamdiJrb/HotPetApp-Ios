//
//  LikeViewModel.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import Foundation
import Alamofire
import SwiftyJSON

class LikeViewModel: ObservableObject {
    
    static let sharedInstance = LikeViewModel()
    
    func add(like: Like, completed: @escaping (Bool, Like?) -> Void) {
        AF.request(BASE_URL + "like",
                   method: .post,
                   parameters: [
                    "likedId": like.liked!._id!,
                    "likerId": like.liker!._id!,
                    "isRight": like.isRight
                   ])
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let like = self.makeItem(jsonItem: JSON(response.data!));
                    print(like)
                    completed(true, like)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getMy(userId: String, completed: @escaping (Bool, [Like]?) -> Void) {
        AF.request(BASE_URL + "like/get-my/" + userId, method: .get)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { [self] response in
                switch response.result {
                case .success:
                    var likes: [Like] = []
                    for singleJsonItem in JSON(response.data!) {
                        likes.append(self.makeItem(jsonItem: singleJsonItem.1))
                    }
                    completed(true, likes)
                case let .failure(error):
                    completed(false, nil)
                    debugPrint(error)
                }
            }
    }
    
    func delete(id: String, completed: @escaping (Bool) -> Void) {
        AF.request(BASE_URL + "like/one/" + id,
                   method: .delete)
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
    
    func makeItem(jsonItem: JSON) -> Like {
        return Like(
            _id: jsonItem["_id"].stringValue,
            liked: UserViewModel.sharedInstance.makeItem(jsonItem: jsonItem["liked"]),
            liker: UserViewModel.sharedInstance.makeItem(jsonItem: jsonItem["liker"]),
            isRight: jsonItem["isRight"].boolValue,
            isMatch: jsonItem["isMatch"].boolValue
        )
    }
}
