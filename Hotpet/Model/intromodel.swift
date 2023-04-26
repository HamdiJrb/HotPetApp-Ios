//
//  intromodel.swift
//  hotpet
//
//  Created by Apple Esprit on 11/4/2023.
//

import SwiftUI

// MARK : Intro Model And Sample Intro's
struct Intro : Identifiable{
    var id : String = UUID().uuidString
    var imageName : String
    var title : String
    var description : String
}

var intros : [Intro] = [
    .init(imageName: "profile_on_boarding", title: "Profile", description: "Get a profile to your pet like\nthe one you have on Instagram"),
    .init(imageName: "discover_on_boarding", title: "Discover", description: "Swipe right to like someone\nor swipe left to pass"),
    .init(imageName: "match_on_boarding", title: "It’s a Match !", description: "If they also swipe right\nThen It’s a match!"),
    .init(imageName: "chat_on_boarding", title: "Chat", description: "Only pets you’ve matched with\nCan message you")
]

//MARK : Dummy Text
//let dummyText = "Lorem Ipsum is simply dymmy text of printing and typesetting industry. \nLorem Ipsum is dummy text."
