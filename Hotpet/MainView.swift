//
//  MainView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI

struct Tab {
    let id: Int
    let name: String
    let color: Color
    let image: String
    
    static let tabs = [
        Tab(id: 0, name: "Discover", color: .electricPink, image: "menu_discover"),
        Tab(id: 1, name: "Matches", color: .gold, image: "menu_match"),
        Tab(id: 2, name: "Chat", color: .electricPink, image: "menu_chat"),
        Tab(id: 3, name: "Profile", color: .electricPink,image:"menu_profile")
    ]
}

struct MainView: View {
    let tabs = Tab.tabs
    @State private var selectedTab: Int = 0
    @State var isLoading: Bool = true
    
    var body: some View {
        Group {
            if isLoading {
                LoadingView()
            } else {
                NavigationView {
                    VStack {
                        HStack {
                            Spacer()
                                .frame(width: 10)
                            Text(tabs[selectedTab].name)
                                .font(.system(size: 20))
                            Spacer()
                            NavigationLink(destination: SettingsView()) {
                                Image(systemName: "gear")
                                    .font(.system(size: 15))
                                    .frame(alignment: Alignment.trailing)
                                    .foregroundColor(.primary)
                                    .padding()
                            }
                            Spacer()
                                .frame(width: 5)
                        }
                        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("BackgroundSecondary")/*@END_MENU_TOKEN@*/)
                        .frame(height: 20)
                        TabView(selection: $selectedTab) {
                            HomeView().tag(0)
                            MatchesView().tag(1)
                            ConversationsView().tag(2)
                            MyProfileView().tag(3)
                        }
                        .navigationBarHidden(true)
                        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                        HStack {
                            Spacer()
                            ForEach(tabs, id: \.id) { tab in
                                VStack {
                                    Image(tab.image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 17, height: 17) // modify the width and height here
                                        .onTapGesture {
                                            withAnimation(.easeInOut(duration: 0.5)) {
                                                selectedTab = tab.id
                                            }
                                        }
                                        .colorMultiply(tab.id == selectedTab ? Color("SecondaryColor") : Color("AccentColor"))
                                    Text(tab.name)
                                        .font(.system(size: 15)) // modify the font size here
                                        .foregroundColor(tab.id == selectedTab ? Color("SecondaryColor") : Color("AccentColor"))
                                    Spacer()
                                }
                                // Add a fixed width spacer between each tab
                                Spacer(minLength: 17)
                            }
                            //Spacer()
                        }
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                    }
                    .background(Color(UIColor.systemGroupedBackground).edgesIgnoringSafeArea(.all))
                    .navigationBarHidden(true)
                }
            }
        }.onAppear {
            onAppearCalled()
        }
    }
    
    private func onAppearCalled() {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            isLoading = false
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
            .previewInterfaceOrientation(.portrait)
    }
}
