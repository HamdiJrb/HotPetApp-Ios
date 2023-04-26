//
//  MatchesView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI

struct MatchesView: View {
    
    @State private var likeList: [Like] = []
    @State private var searchText = ""
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText)
            List(likeList.filter{
                searchText.isEmpty ? true : $0.liked!.username.localizedCaseInsensitiveContains(searchText)
            }, id: \._id) { like in
                NavigationLink(destination: ProfileView(user: like.liked!)) {
                    MatchCell(user: like.liked!)
                }
            }
        }.navigationBarHidden(true)
        .onAppear {
            loadData()
        }
    }
    
    func loadData() {
        LikeViewModel.sharedInstance.getMy(userId: loadSession()!._id!) { success, likes in
            if success {
                likeList = []
                for like in likes! {
                    if like.isRight == true && like.isMatch == true {
                        likeList.append(like)
                    }
                }
            }
        }
    }
}

struct MatchCell: View {
    let user: User
    
    
    var body: some View {
        HStack {
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
            Spacer()
                .frame(width: 15)
            VStack(alignment: .leading) {
                Text(user.username)
                    .font(.headline)
                Text(user.about)
                    .foregroundColor(.secondary)
            }
                  Spacer()
                  HStack(spacing: 4) {
                      Button(action: {
                          // handle heart button tap
                      }) {
                          Image("ic_like")
                                      .resizable()
                                      .scaledToFit()
                                      .frame(width: 20, height: 20) // adjust the size as needed
                             
                      }
                      Spacer().frame(width: 6)
                      Button(action: {
                          // handle cross button tap
                      }) {
                          Image("ic_dislike")
                              .renderingMode(.template) // set rendering mode to template
                                      .resizable()
                                      .scaledToFit()
                                      .frame(width: 20, height: 20) // adjust the size as needed
                      }
                  }
              }
              .padding(.horizontal)
          }
      }

struct MatchesView_Previews: PreviewProvider {
    static var previews: some View {
        MatchesView()
    }
}
