//
//  NodeFlagThumb.swift
//  sysvpn-macos
//
//  Created by macbook on 20/11/2022.
//

import Foundation
import Kingfisher
import SwiftUI
struct NodeFlagThumbView: View {
    var image: String?
    var image2: String?
    var size: CGSize = .init(width: 32, height: 32)
    var smallScaler = 0.9
    var addPosition: CGFloat {
        if image2 != nil {
            return size.width / 1.5
        }
        
        return 0
    }

    var totalWidth: CGFloat {
        let image2Width = image2 != nil ? size.width * smallScaler : 0
        return image2Width + size.width - addPosition / 2
    }

    var body: some View {
        ZStack {
            if let image = image2 {
                KFImage(URL(string: image))
                    .resizable()
                    .frame(width: size.width * smallScaler, height: size.height * smallScaler)
                    .cornerRadius(size.width / 2)
                    .opacity(0.8)
                    .offset(x: addPosition / 2 * -1)
            }
            
            Group {
                if let image = image {
                    KFImage(URL(string: image))
                        .resizable()
                        
                } else {
                    Asset.Assets.icFlagEmpty.swiftUIImage
                        .resizable()
                        .cornerRadius(size.width / 2)
                }
            }
            .frame(width: size.width, height: size.height)
            .cornerRadius(size.width / 2)
            .offset(x: addPosition / 2)
        }.frame(width: totalWidth)
    }
}
