//
//  Message.swift
//  HotPet
//
//  Created by Mac2021 on 15/11/2021.
//

import Foundation

struct Message : Identifiable {
    
    internal init(id: UUID? = nil, _id: String? = nil, description: String, date: Date, senderConversation: Conversation, receiverConversation: Conversation) {
        self.id = id
        self._id = _id
        self.description = description
        self.date = date
        self.senderConversation = senderConversation
        self.receiverConversation = receiverConversation
    }
    
    var id: UUID?
    
    var _id: String?
    var description: String
    var date: Date
    
    // relations
    var senderConversation : Conversation
    var receiverConversation : Conversation
}
