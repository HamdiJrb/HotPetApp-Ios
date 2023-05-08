//
//  CardView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI

struct CardView: View {
    var user: User
    
    @State private var selection = 0
    @State private var translation: CGSize = .zero
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                let images = loadImages()
                TabView(selection: $selection) {
                    ForEach(0..<images.count) { index in
                        AsyncImage(url: URL(string: IMAGES_URL + images[index])!) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .clipped()
                                .modifier(ThemeShadow())
                        } placeholder: {
                            Image("placeholder-pet")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geo.size.width - 32)
                                .clipped()
                                .cornerRadius(15)
                                .modifier(ThemeShadow())
                        }
                    }
                }
                .onAppear(perform: {
                    UIScrollView.appearance().bounces = false
                })
                VStack {
                    HStack {
                        if translation.width > 0 {
                            Text("LIKE")
                                .tracking(3)
                                .font(.title)
                                .padding(.horizontal)
                                .foregroundColor(.green)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.green, lineWidth: 3)
                                )
                                .rotationEffect(.degrees(-20))
                            Spacer()
                        } else if translation.width < 0 {
                            Spacer()
                            Text("NOPE")
                                .tracking(3)
                                .font(.title)
                                .padding(.horizontal)
                                .foregroundColor(.red)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(Color.red, lineWidth: 3)
                                )
                                .rotationEffect(.degrees(20))
                        }
                    }.padding(.horizontal, 25)
                    ZStack {
                        Rectangle()
                            .fill(Color.black.opacity(0.001))
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        Spacer()
                        HStack {
                            if selection > 0 {
                                Button(action: { goToPrevPageFix() }) {
                                    Image(systemName: "arrow.left")
                                        .font(.title2)
                                }
                                .foregroundColor(.white)
                                .buttonStyle(BorderedButtonStyle())
                            }
                            Spacer()
                            if selection < images.count - 1 {
                                Button(action: { goToNextPageFix() }) {
                                    Image(systemName: "arrow.right")
                                        .font(.title2)
                                }
                                .foregroundColor(.white)
                                .buttonStyle(BorderedButtonStyle())
                            }
                        }
                    }
                    Spacer()
                    UserInfoView(user: user)
                }
                .padding(.top, 40)
            }
            .background(.white)
            .offset(x: self.translation.width, y: 0)
            .rotationEffect(.degrees(Double(self.translation.width / geo.size.width) * 25), anchor: .bottom)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        self.translation = value.translation
                    }.onEnded { value in
                        withAnimation(.easeInOut) {
                            if translation.width > 150 {
                                like(user: user, isRight: true)
                                self.translation.width = 500
                            } else if translation.width < -150 {
                                like(user: user, isRight: false)
                                self.translation.width = -500
                            } else {
                                self.translation = .zero
                            }
                        }
                    }
            )
            .cornerRadius(15)
            .padding()
        }
    }
    
    func goToPrevPage() {
        selection -= 1
    }
    
    func goToPrevPageFix() {
        goToPrevPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            goToNextPage()
            goToPrevPage()
        }
    }
    
    func goToNextPage() {
        selection += 1
    }
    
    func goToNextPageFix() {
        goToNextPage()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            goToPrevPage()
            goToNextPage()
        }
    }
    
    func loadImages() -> [String] {
        var images: [String] = []
        if (user.imageFilename != nil){
            images.append(user.imageFilename!)
        } else {
            images.append("")
        }
        
        for image in user.images {
            if image != user.imageFilename {
                images.append(image)
            }
        }
        return images
    }
    
    func like(user: User, isRight: Bool){
        let like = Like(liked: user, liker: loadSession()!, isRight: isRight, isMatch: false)
        LikeViewModel.sharedInstance.add(like: like) { success, like  in
            if success {
                
            }
        }
    }
}

struct UserInfoView: View {
    let user: User
    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .bottom) {
                VStack(spacing: 5) {
                    HStack{}
                    Text(user.username + ", " + String(DateUtils.getAge(date: user.birthdate)) + "yo")
                        .foregroundColor(Color.black)
                        .font(.system(size: 20).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text(user.about)
                        .font(.system(size: 17).weight(.medium))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(Color.secondary)
                }
                //Text(String(DateUtils.getAge(date: user.birthdate)) + "yo")
                    //.frame(width: 30, height: 30, alignment: .center)
            }
            .padding()
        }
        .foregroundColor(.black)
        .background(.white)
        .clipped()
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(
            user:
                User(
                    id: UUID(),
                    _id: "",
                    email: "",
                    password: "",
                    username: "",
                    birthdate: Date(),
                    gender: Gender.Unspecified,
                    category: Category.Unspecified,
                    about: "",
                    preferredAgeMin: 0,
                    preferredAgeMax: 0,
                    preferredDistance: 0,
                    latitude: 0,
                    longitude: 0,
                    imageFilename: "DOG_1.jpg",
                    images: [
                        "DOG_1.jpg",
                        "IMAGE_1681654618935.jpg",
                        "IMAGE_1681654625599.jpg"
                    ],
                    isVerified: true
                )
        ).preferredColorScheme(.dark)
    }
}
