//
//  ProfileView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    var user: User
    
    @State var shouldRefresh = false
    
    @State private var isNavigateToEditProfile = false
    
    @State private var selectedImageUrl: URL?
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    @State private var showSettings = false
    
    
    var body: some View {
        ScrollView {
            VStack {
                Spacer().frame(height: 75)
                AsyncImage(url: URL(string: IMAGES_URL + (user.imageFilename ?? ""))!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 115, height: 115)
                        .clipShape(Circle())
                        //.overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } placeholder: {
                    Image("placeholder-pet")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 115, height: 115)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                }
                
                HStack {
                    Text(user.username + ", " + String(DateUtils.getAge(date: user.birthdate)) + "yo").bold()
                        .font(.custom("Nexa-Bold", size: 22))
                }.frame(maxWidth: .infinity, alignment: .center)
                    .padding(.bottom, 10)
                HStack {
                    Spacer().frame(width: 40)
                

                    NavigationLink(
                        destination: EditProfileView(shouldRefresh: $shouldRefresh),
                        isActive: $isNavigateToEditProfile
                    ){
                        EmptyView()
                    }
                   
                }
                Spacer().frame(height: 2)
                VStack (spacing: 15) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 15, weight: .heavy))
                        Text(user.about)
                            .font(.system(size: 16))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    /*HStack {
                     Image(systemName: "person.text.rectangle")
                     .font(.system(size: 20, weight: .heavy))
                     Text(user.username + " " + String(DateUtils.getAge(date: user.birthdate)) + "yo")
                     }.frame(maxWidth: .infinity, alignment: .leading)*/
                    /*HStack {
                     Image(systemName: "calendar")
                     .font(.system(size: 20, weight: .heavy))
                     Text("Age : " + String(DateUtils.getAge(date: user.birthdate)))
                     }.frame(maxWidth: .infinity, alignment: .leading)*/
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 15, weight: .heavy))
                        Text(user.category.description)
                            .font(.system(size: 16))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "link")
                            .font(.system(size: 15, weight: .heavy))
                        Text(user.gender.description)
                            .font(.system(size: 16))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 60)
            }
            .background(
                        Image("backrgound_image")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height:70)
                            .edgesIgnoringSafeArea(.all)
                            .padding(.top, -150)
                    )
            Spacer().frame(height: 35)
            Text("Posts")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                .font(.title)
            Spacer().frame(height: 15)
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    if user.images.isEmpty ?? true {
                        Text("No images")
                    } else {
                        ForEach(user.images, id: \.self) { imageFilename in
                            AsyncImage(url: URL(string: IMAGES_URL + imageFilename)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(15)
                                    .modifier(ThemeShadow())
                            } placeholder: {
                                Image("placeholder-pet")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(15)
                                    .modifier(ThemeShadow())
                            }
                        }
                    }
                }
            }.padding()
                .background(Color("BackgroundSecondary"))
            Spacer().frame(width: 20)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(
            user: User(
                _id: "639e44145834d0ba12a6d7d7",
                email: "email@email.com",
                password: "1123456",
                username: "TestUser",
                birthdate: Date(),
                gender: Gender.Female,
                category: Category.Horse,
                about: "This is the about",
                images: []
            )
        );
    }
}
