//
//  ChatViewModel.swift
//  HotPet
//
//  Created by User on 26/11/2021.
//

import Foundation
import SwiftyJSON
import Alamofire

public class ChatViewModel: ObservableObject{
    
    static let sharedInstance = ChatViewModel()
    
    func getMyConversations(completed: @escaping (Bool, [Conversation]?) -> Void ) {
        AF.request(BASE_URL + "chat/my-conversations/" + loadSession()!._id!,
                   method: .get,
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var conversation : [Conversation]? = []
                    for singleJsonItem in jsonData {
                        conversation!.append(self.makeConversation(jsonItem: singleJsonItem.1))
                    }
                    completed(true, conversation)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func getMyMessages(conversationId: String, completed: @escaping (Bool, [Message]?) -> Void ) {
        AF.request(BASE_URL + "chat/my-messages/" + conversationId,
                   method: .get,
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    let jsonData = JSON(response.data!)
                    
                    var messages : [Message]? = []
                    for singleJsonItem in jsonData {
                        messages!.append(self.makeMessage(jsonItem: singleJsonItem.1))
                    }
                    completed(true, messages)
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func createConversation(senderId: String, receiverId: String, completed: @escaping (Bool, Conversation?) -> Void ) {
        AF.request(BASE_URL + "chat/add-conversation",
                   method: .post,
                   parameters: [
                    "sender" : senderId,
                    "receiver" : receiverId
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, self.makeConversation(jsonItem: JSON(response.data!)))
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func sendMessage(receiverId: String, description: String, completed: @escaping (Bool, Message?) -> Void ) {
        AF.request(BASE_URL + "chat/send-message",
                   method: .post,
                   parameters: [
                    "senderId": loadSession()!._id!,
                    "receiverId": receiverId,
                    "description": description
                   ],
                   encoding: JSONEncoding.default)
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseData { response in
                switch response.result {
                case .success:
                    completed(true, self.makeMessage(jsonItem: JSON(response.data!)))
                case let .failure(error):
                    debugPrint(error)
                    completed(false, nil)
                }
            }
    }
    
    func makeMessage(jsonItem: JSON) -> Message {
        return Message(
            _id: jsonItem["_id"].stringValue,
            description: jsonItem["description"].stringValue,
            date: DateUtils.formatFromString(string: jsonItem["date"].stringValue),
            senderConversation: makeConversation(jsonItem: jsonItem["senderConversation"]),
            receiverConversation: makeConversation(jsonItem: jsonItem["receiverConversation"])
        )
    }
    
    func makeConversation(jsonItem: JSON) -> Conversation {
        return Conversation(
            _id: jsonItem["_id"].stringValue,
            lastMessage: jsonItem["lastMessage"].stringValue,
            lastMessageDate: DateUtils.formatFromString(string: jsonItem["lastMessageDate"].stringValue),
            sender: UserViewModel.sharedInstance.makeItem(jsonItem: jsonItem["sender"]),
            receiver: UserViewModel.sharedInstance.makeItem(jsonItem: jsonItem["receiver"])
        )
    }
}
