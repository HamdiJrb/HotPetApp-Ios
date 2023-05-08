//
//  MatchesView.swift
//  Hotpet
//
//
//

import SwiftUI

struct MatchesView: View {
    
    @State private var likeList: [Like] = []
    @State private var searchText = ""
    
    @State private var isPremium = false
    @State private var showingAlert = false
    @State private var alert: Alert?
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List(likeList.filter{
                searchText.isEmpty ? true : $0.liker!.username.localizedCaseInsensitiveContains(searchText)
            }, id: \._id) { like in
                if isPremium {
                    Button(action: {
                        //like(user: like.liker!, isRight: true)
                    }) {
                        MatchCell(user: like.liker!)
                    }
                } else {
                    MatchCell(user: like.liker!)
                        .blur(radius: 5)
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            loadData()
        }
        .overlay(
            isPremium ?
                nil :
                Button(action: {
                    isPremium = true
                    alert = AlertMaker.makeAlert(
                        title: "Congratulations !",
                        message: "Now you can see your matches"
                    )
                    showingAlert = true
                }) {
                    Text("Go Premium")
                        .foregroundColor(.white)
                }
                .font(.system(size: 20).weight(.semibold))
                .padding(10)
                .frame(width: 250)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color("SecondaryColor"), Color("AccentColor")]),
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .cornerRadius(15)
                .foregroundColor(.white)
                .padding(.top, UIApplication.shared.windows.first?.safeAreaInsets.top)
            )
        .alert(isPresented: $showingAlert) {
                alert!
            }
    }
    
    func loadData() {
        LikeViewModel.sharedInstance.getMy(userId: loadSession()!._id!) { success, likes in
            if success {
                likeList = []
                for like in likes! {
                    if like.isRight == true && loadSession()!._id! != like.liker?._id {//&& like.isMatch == false {
                        likeList.append(like)
                    }
                }
            }
        }
    }
}

struct MatchCell: View {
    let user: User
    
    //
    @State private var showingAlert = false
    @State private var alert: Alert?
    @State private var isDislikeButtonVisible = true
    @State private var isButtonsVisible = true
    
    @State private var isShowingProfile = false
    
    
    func like(user: User, isRight: Bool){
        let like = Like(liked: user, liker: loadSession()!, isRight: isRight, isMatch: false)
        LikeViewModel.sharedInstance.add(like: like) { success, likeFromApi in
            if success {
                
                
                
                if likeFromApi!.isMatch {
                    alert =  AlertMaker.makeAlert(
                        title: "Match !",
                        message: "You successfully matched with " +
                        like.liked!.username +
                        " a new conversation has been created."
                    )
                    showingAlert = true
                    
                    
                    ChatViewModel.sharedInstance.createConversation(senderId: loadSession()!._id!, receiverId: likeFromApi!.liker!._id!) { success, conversation in
                        
                    }
                    
                    ChatViewModel.sharedInstance.createConversation(senderId: likeFromApi!.liker!._id!, receiverId: loadSession()!._id!) { success, conversation in
                        
                    }
                }
            }
        }
    }
    
    var body: some View {
        HStack {
            Button(action: { isShowingProfile.toggle() }) {
                AsyncImage(url: URL(string: IMAGES_URL + (user.imageFilename ?? ""))!) { image in
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
            }
            Spacer().frame(width: 15)
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.headline)
                Text(user.about)
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            Spacer()
            HStack(spacing: 4) {
                if isButtonsVisible {
                                Button(action: {
                                    alert = AlertMaker.makeAlert(
                                        title: "Success !",
                                        message: "It's a Match !"
                                    )
                                    showingAlert = true
                                    isButtonsVisible = false
                                    like(user: user, isRight: true)
                                    /*UserDefaults.standard.set(false, forKey: "isButtonsVisible")*/
                                }) {
                                    Image("ic_like")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                                Spacer().frame(width: 6)
                                Button(action: {
                                    alert = AlertMaker.makeAlert(
                                        title: "OOOPS !",
                                        message: "It's a Dislike"
                                    )
                                    showingAlert = true
                                    isButtonsVisible = false
                                    /*UserDefaults.standard.set(false, forKey: "isButtonsVisible")*/
                                }) {
                                    Image("ic_dislike")
                                        .renderingMode(.template)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                }
                            }
                        }
                        /*.onAppear {
                            if let isButtonsVisible = UserDefaults.standard.object(forKey: "isButtonsVisible") as? Bool {
                                self.isButtonsVisible = isButtonsVisible
                            }
                        }*/
                    }
                            .background(
                                NavigationLink(destination: ProfileView(user: user), isActive: $isShowingProfile) {
                                    EmptyView()
                                }
                                .hidden()
                            )
                            .alert(isPresented: $showingAlert) {
                                alert!
                            }
                        }
                    }



struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
