//
//  ProfileView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI
import PhotosUI

struct MyProfileView: View {
    
    @State var shouldRefresh = false
    
    @State private var showingAlert = false
    @State private var alert: Alert?
    
    @State private var isNavigateToEditProfile = false
    @State private var isNavigateToLogin = false
    
    @State var user = loadSession()!
    
    @State private var selectedImageUrl: URL?
    @State private var shouldPresentImagePicker = false
    @State private var shouldPresentActionScheet = false
    @State private var shouldPresentCamera = false
    
    @State private var showSettings = false
    
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Spacer().frame(height: 10)
                AsyncImage(url: URL(string: IMAGES_URL + (user.imageFilename ?? ""))!) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                } placeholder: {
                    Image("placeholder-pet")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                        .shadow(radius: 10)
                }
                
                HStack {
                    Text(loadSession()!.username + ", " + String(DateUtils.getAge(date: loadSession()!.birthdate)) + "yo").bold()
                        .font(.custom("Nexa-Bold", size: 30))
                }.frame(maxWidth: .infinity, alignment: .center)
                ////// // settings button
                ///
                //////////////
                HStack {
                    Spacer().frame(width: 40)
                    Button("Edit profile") {
                        isNavigateToEditProfile = true
                    }.foregroundColor(.white)
                        .padding(3)
                        .font(.system(size: 15))
                        .frame(width: 140, height: 35)
                        .background(Color("AccentColor"))
                        .cornerRadius(15)
                        .labelStyle(DefaultLabelStyle())
                    Spacer().frame(width: 30)
                        .onChange(of: shouldRefresh) { value in
                            if value {
                                refreshPage()
                            }
                        }
                    NavigationLink(
                        destination: EditProfileView(shouldRefresh: $shouldRefresh),
                        isActive: $isNavigateToEditProfile
                    ){
                        EmptyView()
                    }
                    Button("Logout") {
                        resetSession()
                        isNavigateToLogin = true
                    }.foregroundColor(.white)
                        .padding(3)
                        .font(.system(size: 15))
                        .frame(width: 140, height: 35)
                        .background(.red)
                        .cornerRadius(15)
                        .labelStyle(DefaultLabelStyle())
                        .fullScreenCover(isPresented: $isNavigateToLogin, content: {
                            LoginView(initialEmail: loadLastLoggedEmail())
                        })
                    Spacer().frame(width: 40)
                }
                Spacer().frame(height: 2)
                VStack (spacing: 15) {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 15, weight: .heavy))
                        Text(loadSession()!.about)
                            .font(.system(size: 20))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    /*HStack {
                        Image(systemName: "person.text.rectangle")
                            .font(.system(size: 20, weight: .heavy))
                        Text(loadSession()!.username + " " + String(DateUtils.getAge(date: loadSession()!.birthdate)) + "yo")
                    }.frame(maxWidth: .infinity, alignment: .leading)*/
                    /*HStack {
                        Image(systemName: "calendar")
                            .font(.system(size: 20, weight: .heavy))
                        Text("Age : " + String(DateUtils.getAge(date: loadSession()!.birthdate)))
                    }.frame(maxWidth: .infinity, alignment: .leading)*/
                    HStack {
                        Image(systemName: "pawprint.fill")
                            .font(.system(size: 15, weight: .heavy))
                        Text(loadSession()!.category.description)
                            .font(.system(size: 20))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    HStack {
                        Image(systemName: "link")
                            .font(.system(size: 15, weight: .heavy))
                        Text(loadSession()!.gender.description)
                            .font(.system(size: 20))
                    }.frame(maxWidth: .infinity, alignment: .leading)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 60)
            }
            Spacer().frame(height: 35)
            Text("Posts")
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 30)
                .font(.title)
            Spacer().frame(height: 15)
            ScrollView(.horizontal){
                HStack(spacing: 20) {
                    if loadSession()?.images.isEmpty ?? true {
                        Text("No images")
                    } else {
                        ForEach(loadSession()!.images, id: \.self) { imageFilename in
                            VStack {
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
                                Spacer(minLength: 15)
                                Button("Set as profile pic") {
                                    setAsProfilePicture(imageFileName: imageFilename)
                                }
                                Spacer(minLength: 15)
                                Button("Delete") {
                                    deletePicture(imageFileName: imageFilename)
                                }.foregroundColor(.red)
                                Spacer(minLength: 15)
                            }
                        }
                    }
                }
            }.padding()
                .background(Color(.white))//("BackgroundSecondary"))
            Spacer().frame(width: 20)
            Button("+") {
                shouldPresentActionScheet = true
            }
            .font(.system(size: 30))
            .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Color("AccentColor"))
                .cornerRadius(45)
                .padding(.horizontal, 5)
                .labelStyle(DefaultLabelStyle())
                .sheet(isPresented: $shouldPresentImagePicker,onDismiss: {
                    savePicture()
                }) {
                    SUImagePickerView(sourceType: self.shouldPresentCamera ? .camera : .photoLibrary, selectedimageUrl: self.$selectedImageUrl, isPresented: self.$shouldPresentImagePicker)
                }
                .actionSheet(isPresented: $shouldPresentActionScheet) { () -> ActionSheet in
                    ActionSheet(title: Text("Choose mode"), message: Text("Please choose your preferred mode to set your profile image"), buttons: [ActionSheet.Button.default(Text("Camera"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = true
                    }), ActionSheet.Button.default(Text("Photo Library"), action: {
                        self.shouldPresentImagePicker = true
                        self.shouldPresentCamera = false
                    }), ActionSheet.Button.cancel()])
                }
            Spacer().frame(height: 20)
        }
        .alert(isPresented: $showingAlert) {
            alert!
        }
    }
    
    func refreshPage(){
        user = loadSession()!
        shouldRefresh = false
    }
    
    func savePicture(){
        if selectedImageUrl != nil {
            UserViewModel.sharedInstance.addImage(email: user.email, imageUrl: selectedImageUrl!) { success in
                if success {
                    UserViewModel.sharedInstance.getOne(_id: user._id!) { success, user in
                        if success {
                            saveSession(user: user!)
                            refreshPage()
                        }
                    }
                }
            }
        }
    }
    
    func setAsProfilePicture(imageFileName: String) {
        alert = AlertMaker.makeActionAlert(title: "Warning", message: "Are you sure you want to make this picture as your profile pic", action: Alert.Button.default(
            Text("Yes"), action: {
                UserViewModel.sharedInstance.updateProfileImage(email: user.email, imageFilename: imageFileName) { success in
                    if success {
                        UserViewModel.sharedInstance.getOne(_id: user._id!) { success, user in
                            if success {
                                saveSession(user: user!)
                                refreshPage()
                            }
                        }
                    }
                }
            }
        ))
        showingAlert = true
    }
    
    func deletePicture(imageFileName: String) {
        alert = AlertMaker.makeActionAlert(title: "Warning", message: "Are you sure you want to delete this picture", action: Alert.Button.default(
            Text("Yes"), action: {
                UserViewModel.sharedInstance.deleteImage(email: user.email, imageFilename: imageFileName) { success, image  in
                    if success {
                        UserViewModel.sharedInstance.getOne(_id: user._id!) { success, user in
                            if success {
                                saveSession(user: user!)
                                refreshPage()
                            }
                        }
                    }
                }
            }
        ))
        showingAlert = true
    }
}

struct MyProfileViewView_Previews: PreviewProvider {
    static var previews: some View {
        MyProfileView()
    }
}
