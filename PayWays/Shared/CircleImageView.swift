//
//  CircleImageView.swift
//  PayWays
//
//  Created by Арсений Крохалев on 08.02.2021.
//

import SwiftUI

struct CircleImageView: View {
    let text: String
    let size: CGFloat
    
    var body: some View {
        Text(text)
            .font(.system(size: size / 3))
            .frame(width: size, height: size)
//            .fixedSize(horizontal: false, vertical: false)
            .background(Circle()
                .fill(Color.red)
                .frame(width: size, height: size))
            .clipped()
    }
}

struct CircleImageView_Previews: PreviewProvider {
    static var previews: some View {
        CircleImageView(text: "HW", size: 100)
    }
}
