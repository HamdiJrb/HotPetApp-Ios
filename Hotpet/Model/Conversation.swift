//
//  Conversation.swift
//  HotPet
//
//  Created by Mac2021 on 15/11/2021.
//

import Foundation

struct Conversation: Identifiable{
    
    internal init(_id: String? = nil, lastMessage: String, lastMessageDate: Date, sender: User, receiver: User) {
        self._id = _id
        self.lastMessage = lastMessage
        self.lastMessageDate = lastMessageDate
        self.sender = sender
        self.receiver = receiver
    }
    
    var id: UUID?
    var _id : String?
    var lastMessage : String
    var lastMessageDate : Date
    
    // relations
    var sender : User
    var receiver : User
}
