//
//  HomeListProfileView.swift
//  sysvpn-macos
//
//  Created by doragon on 29/11/2022.
//

import SwiftUI

struct HomeListProfileView: View {
    @State var textInput: String = ""
    var listProfile: [HomeListProfileModel]
    var onTapCreate: (() -> Void)?
    
    var body: some View {
        VStack(alignment: .leading) {
            headerListProfile
            Spacer().frame(height: 24 )
            ScrollView([.vertical], showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(listProfile) { item in
                        Group {
                            switch item.type {
                            case .spacing:
                                Spacer().frame(height: 30)
                            case .body:
                                HomeItemProfile(title: item.title)
                            case .header:
                                VStack {
                                    Text(item.title)
                                        .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                                        .font(Font.system(size: 12, weight: .regular))
                                    Spacer().frame(height: 20)
                                }
                                
                            }
                        }
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(maxHeight: .infinity)
    }
    
    
    var headerListProfile: some View {
        HStack (spacing: 16){
            SearchInputView(textInput: $textInput)
                .padding(.top, 2)
            HStack(spacing: 8) {
                Asset.Assets.icAdd.swiftUIImage
                    .resizable()
                    .frame(width: 14, height: 14)
                Text(L10n.Global.create)
                    .foregroundColor(Asset.Colors.primaryColor.swiftUIColor)
                    .font(Font.system(size: 13, weight: .medium))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                // add new
                onTapCreate?()
            }
        }
    }
      
}


struct HomeItemProfile: View {
    var sizeDot: CGFloat = 4.0
    var title: String
    var body: some View {
        HStack (spacing: 16) {
            Asset.Assets.icGame.swiftUIImage
                .resizable()
                .frame(width: 16, height: 16)
            Text(title)
                .font(Font.system(size: 13, weight: .medium))
                .foregroundColor(Color.white)
            Spacer()
            HStack(alignment: .center, spacing: 2) {
                Circle()
                    .frame(width: sizeDot, height: sizeDot)
                    .foregroundColor(.white)
                Circle()
                    .frame(width: sizeDot, height: sizeDot)
                    .foregroundColor(.white)
                Circle()
                    .frame(width: sizeDot, height: sizeDot)
                    .foregroundColor(.white)
            }
        }
        .frame(height: 44)
    }
}

enum HomeListProfileModelType {
    case header
    case body
    case spacing
}


struct HomeListProfileModel: Identifiable, Equatable {
    static func == (lhs: HomeListProfileModel, rhs: HomeListProfileModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var type: HomeListProfileModelType
    var title: String = ""
    var imageUrl: String?
    var profileDetail: UserProfileProtocol?
}
 
