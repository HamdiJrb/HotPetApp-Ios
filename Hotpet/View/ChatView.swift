//
//  ChatView.swift
//  Hotpet
//
//  Created by Grim on 29/3/2023.
//

import SwiftUI

struct ChatView: View {
    
    let currentConversation: Conversation
    
    @State private var messageText = ""
    @State private var messages: [Message] = []
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 20) {
                    ForEach(messages, id: \._id) { message in
                        MessageView(message: message)
                    }
                }
            }
            .padding()
            HStack {
                TextField("Type a message", text: $messageText)
                    .textFieldStyle(.roundedBorder)
                    .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color.accentColor, lineWidth: 2)
                        )
                Button(action: sendMessage){
                   Image("send_ic")
                               .resizable()
                               .scaledToFit()
                               .frame(width: 20, height: 20) // adjust the size as needed
                      
               }
                /*Button(action: sendMessage) {
                    Text("Send")
                }*/
                .disabled(messageText.isEmpty)
            }
            .padding()
        }
        .navigationTitle(currentConversation.receiver.username)
        .onAppear {
            ChatViewModel.sharedInstance.getMyMessages(conversationId: currentConversation._id!) { success, messageList in
                if success {
                    messages = messageList!
                }
            }
        }
    }
    
    private func sendMessage() {
        ChatViewModel.sharedInstance.sendMessage(receiverId: currentConversation.receiver._id!, description: messageText) { success, message in
            if success {
                ChatViewModel.sharedInstance.getMyMessages(conversationId: currentConversation._id!) { success, messageList in
                    if success {
                        messages = messageList!
                    }
                }
                messageText = ""
            } else {
                
            }
        }
    }
}

struct MessageView: View {
    
    let message: Message
    
    var body: some View {
        HStack {
            if message.senderConversation.sender._id == loadSession()?._id {
                Spacer()
                Text(message.description)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.accentColor)
                    .clipShape(ChatBubble(isFromCurrentUser: true))
            } else {
                Text(message.description)
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.gray)
                    .clipShape(ChatBubble(isFromCurrentUser: false))
                Spacer()
            }
        }
    }
}

struct ChatBubble: Shape {
    
    let isFromCurrentUser: Bool
    
    func path(in rect: CGRect) -> Path {
        let bubblePath = UIBezierPath(roundedRect: rect, byRoundingCorners: [.topLeft, .topRight, isFromCurrentUser ? .bottomLeft : .bottomRight], cornerRadii: CGSize(width: 10, height: 2))
        return Path(bubblePath.cgPath)
    }
}
