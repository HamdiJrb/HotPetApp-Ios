//
//  LikesView.swift
//  Hotpet
//
//  Created by Grim on 13/2/2023.
//

import SwiftUI

struct LikesView: View {
    @State private var selected = 0
    
    var body: some View {
        VStack {
            LikesSegmentView()
        }
    }
}

struct LikesView_Previews: PreviewProvider {
    static var previews: some View {
        LikesView()
    }
}

struct LikesSegmentView: View {
    var body: some View {
        VStack(spacing: 40) {
            Spacer()
            Image(systemName: "suit.heart.fill")
                .font(.system(size: 60))
                .foregroundColor(Color.gray.opacity(0.3))
            Text("You don't have any likes yet.")
                .frame(width: 230)
                .multilineTextAlignment(.center)
                .foregroundColor(.gray)
            Spacer()
        }
    }
}
