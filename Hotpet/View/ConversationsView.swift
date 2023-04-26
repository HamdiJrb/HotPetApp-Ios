//
//  ConversationsView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI

struct ConversationsView: View {
    
    @State private var conversations: [Conversation] = []
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List(conversations.filter{
                searchText.isEmpty ? true : $0.receiver.username.localizedCaseInsensitiveContains(searchText)
            }, id: \._id) { conversation in
                NavigationLink(destination: ChatView(currentConversation: conversation)) {
                    ConversationCell(conversation: conversation)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        ChatViewModel.sharedInstance.getMyConversations { success, conversationList in
            if success {
                conversations = conversationList!
            }
        }
    }
}

struct ConversationCell: View {
    let conversation: Conversation
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: IMAGES_URL + (conversation.receiver.imageFilename ?? ""))!) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipped()
                    .cornerRadius(15)
                    .modifier(ThemeShadow())
            } placeholder: {
                Image("placeholder-pet")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipped()
                    .cornerRadius(15)
                    .modifier(ThemeShadow())
            }
            Spacer()
                .frame(width: 15)
            VStack(alignment: .leading) {
                Text(conversation.receiver.username.isEmpty ? conversation.receiver.email : conversation.receiver.username)
                    .font(.headline)
                Text(conversation.lastMessage)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct SearchBar: UIViewRepresentable {
    @Binding var text: String
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var text: String
        
        init(text: Binding<String>) {
            _text = text
        }
        
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            text = searchText
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
        let searchBar = UISearchBar(frame: .zero)
        searchBar.delegate = context.coordinator
        searchBar.placeholder = "Search"
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
        uiView.text = text
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
    }
}
