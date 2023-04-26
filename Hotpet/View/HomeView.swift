//
//  HomeView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI
import CoreLocation

struct HomeView: View {
    
    
    @State private var users: [User] = []
    
    
    @State private var showingAlert = false
    @State private var alert: Alert?
    
    @StateObject var locationManager = LocationManager()
    
    var body: some View {
        VStack {
            if (locationManager.locationStatus == .authorizedWhenInUse ) {
                ZStack {
                    if users.isEmpty {
                        VStack {
                            Spacer()
                            Text("No content")
                            Spacer()
                        }
                    } else {
                        ForEach(users, id: \._id) { user in
                            CardView(user: user)
                                .shadow(radius: 5)
                        }
                    }
                }
                .onAppear(perform: {
                    loadData()
                })
            } else {
                Text("Location is required")
            }
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Button(action: {
                    if (!users.isEmpty) {
                        like(user: users.last!, isRight: false)
                    }
                }) {
                    Image("ic_dislike")
                        .font(.system(size: 18, weight: .heavy))
                        .frame(width: 70, height: 70)
                        .modifier(ButtonBG())
                        .scaledToFill()
                        .cornerRadius(28)
                        .modifier(ThemeShadow())
                }
                Spacer()
                Button(action: {
                    
                }) {
                    Image("ic_paw")
                        .font(.system(size: 18, weight: .heavy))
                        .frame(width: 50, height: 50)
                        .modifier(ButtonBG())
                        .scaledToFill()
                        .cornerRadius(20)
                        .modifier(ThemeShadow())
                }
                Spacer()
                Button(action: {
                    if (!users.isEmpty) {
                        like(user: users.last!, isRight: true)
                    }
                }) {
                    Image("ic_like")
                        .font(.system(size: 18, weight: .heavy))
                        .frame(width: 70, height: 70)
                        .modifier(ButtonBG())
                        .scaledToFill()
                        .cornerRadius(28)
                        .modifier(ThemeShadow())
                }
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 5)
        }
        .alert(isPresented: $showingAlert) {
            alert!
        }
        .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color("BackgroundSecondary")/*@END_MENU_TOKEN@*/)
    }
    
    func loadData(){
        users = []
        UserViewModel.sharedInstance.getAll { success, usersList in
            if success {
                LikeViewModel.sharedInstance.getMy(userId: loadSession()!._id!, completed: { success, likeList in
                    if success {
                        for user in usersList! {
                            if (checkFilters(user: user, currentUser: loadSession()!, likes: likeList!)){
                                users.append(user)
                            }
                        }
                        
                        let userLatitude = locationManager.lastLocation?.coordinate.latitude ?? 0
                        let userLongitude = locationManager.lastLocation?.coordinate.longitude ?? 0
                        
                        UserViewModel.sharedInstance.updateLocation(email: loadSession()!.email, latitude: userLatitude, longitude: userLongitude) { success in
                            if success {
                                
                            } else {
                                print("Error saving location")
                            }
                        }
                    }
                })
            }
        }
    }
    
    func like(user: User, isRight: Bool){
        let like = Like(liked: user, liker: loadSession()!, isRight: isRight, isMatch: false)
        LikeViewModel.sharedInstance.add(like: like) { success, likeFromApi in
            if success {
                users.removeLast()
                
                
                if likeFromApi!.isMatch {
                    alert =  AlertMaker.makeAlert(
                        title: "Match !",
                        message: "You successfully matched with " +
                        like.liker!.username +
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
    
    func checkFilters(user: User, currentUser: User, likes: [Like]) -> Bool {
        if (user._id == currentUser._id) {
            // User is you
            print(user.username + " - User is you")
            return false
        } else {
            if ((user.category != currentUser.category) || (user.gender == currentUser.gender)) {
                // Category or gender is not valid
                print(user.username + " - Category (" + user.category.description + ") or gender (" + user.gender.description + ") is not valid")
                return false
            } else {
                if (user.latitude == nil || user.longitude == nil) {
                    // User has no location
                    print(user.username + " - User has no location")
                    return false
                } else {
                    
                    let userLatitude = locationManager.lastLocation?.coordinate.latitude ?? 0
                    let userLongitude = locationManager.lastLocation?.coordinate.longitude ?? 0
                    
                    let distance: Double = calculateDistance(
                        from: CLLocationCoordinate2D(
                            latitude: user.latitude!,
                            longitude: user.longitude!
                        ),
                        to: CLLocationCoordinate2D(
                            latitude: userLatitude,
                            longitude: userLongitude
                        )
                    )
                    if (distance > Double(loadSession()!.preferredDistance! * 1000)) {
                        // User is far away
                        print(user.username + " - User is far away / Distance = " + String(distance))
                        return false
                    } else {
                        let age = Calendar.current.dateComponents([.year], from: user.birthdate, to: Date()).year ?? 0
                        if !(loadSession()!.preferredAgeMin!...loadSession()!.preferredAgeMax!).contains(age) {
                            // Age is not in range
                            print("\(user.username) - Age (" + String(age) + ") is not in range")
                            return false
                        } else {
                            for like in likes {
                                if ((like.liker?._id == currentUser._id) && (like.liked?._id == user._id)) {
                                    // User is liked by you
                                    print(user.username + " - User is liked by you")
                                    return false
                                }
                                if ((like.liker?._id == user._id) && (like.liked?._id == currentUser._id) && (like.isMatch)) {
                                    // User is likes you && matched
                                    print(user.username + " - User is likes you && matched")
                                    return false
                                }
                            }
                        }
                    }
                }
            }
        }
        print(user.username + " - User Accepted")
        return true
    }
    
    func calculateDistance(from startCoordinate: CLLocationCoordinate2D, to endCoordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        let startLocation = CLLocation(latitude: startCoordinate.latitude, longitude: startCoordinate.longitude)
        let endLocation = CLLocation(latitude: endCoordinate.latitude, longitude: endCoordinate.longitude)
        return startLocation.distance(from: endLocation)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
