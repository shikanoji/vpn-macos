//
//  ProfileSelectLocationView.swift
//  sysvpn-macos
//
//  Created by doragon on 29/11/2022.
//

import SwiftUI

struct ProfileSelectLocationView: View {
    
    @State var searchInput: String = ""
    @State var profileInput: String = ""
    @State var indexSelect: Int = 0
    var onCancel: (() -> Void)?
    var isEdit: Bool = false
    @StateObject var viewModel = ProfileSelectLocationViewModel()
    
    private let adaptiveColums = [
        GridItem(.adaptive(minimum: 120))
    ]
    
    var body: some View {
        VStack (alignment: .leading, spacing: 24) {
            if !isEdit {
                profileInputItem
            } 
            searchItem
            listItemCountry
                .frame(height: 230)
            HStack (spacing: 16){
                Button {
                    onCancel?()
                } label: {
                    Text(L10n.Global.cancel)
                        .foregroundColor(.white)
                        .font(Font.system(size: 13, weight: .semibold))
                }
                .frame(height: 40)
                .buttonStyle(ButtonCTAStyle(bgColor:Asset.Colors.popoverBgSelected.swiftUIColor, radius: 6))
                 
                Button {
                } label: {
                    Text(L10n.Global.create)
                        .foregroundColor(.black)
                        .font(Font.system(size: 13, weight: .semibold))
                }
                .frame(height: 40)
                .buttonStyle(ButtonCTAStyle(bgColor:Asset.Colors.primaryColor.swiftUIColor, radius: 6))
            }
        }
        .padding(32)
        .frame(width: 470, height: 580)
        .background(Asset.Colors.bodySettingColor.swiftUIColor)
        .cornerRadius(16)
        
    }
    
    var profileInputItem: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(L10n.Global.createNewProfile)
                .foregroundColor(.white)
                .font(Font.system(size: 16, weight: .semibold))
            HStack(spacing: 0) {
                Spacer().frame(width: 20)
                TextField(L10n.Global.profileName, text: $profileInput)
                    .textFieldStyle(PlainTextFieldStyle())
                Spacer().frame(width: 20)
            }
            .frame(height: 50)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(style: .init(lineWidth: 1.2))
                .foregroundColor(Asset.Colors.borderColor.swiftUIColor))
        }
        
    }
    
    var searchItem: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(L10n.Global.selectLocation)
                .foregroundColor(.white)
                .font(Font.system(size: 14, weight: .regular))
            SearchInputView(textInput: $searchInput, borderColor: Asset.Colors.borderColor.swiftUIColor)
                .padding(.top, 2)
        }
    }
    
    var listItemCountry: some View {
        VStack (alignment: .leading) {
            ScrollView (showsIndicators: false) {
                LazyVGrid (columns: adaptiveColums, alignment: .leading, spacing: 16) {
                    ForEach (viewModel.listCountry) { item in
                        HStack (spacing: 0) {
                            if item.image != nil {
                                item.image!
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(14)
                                    .padding(8)
                            } else {
                                Asset.Assets.icFlagEmpty.swiftUIImage
                                    .resizable()
                                    .frame(width: 28, height: 28)
                                    .cornerRadius(14)
                            } 
                            Text(item.name ?? "")
                                .foregroundColor(Color.white)
                                .font(Font.system(size: 12, weight: .regular))
                            Spacer()
                        }
                        .frame(width: 128)
                        .background(item.id == indexSelect ? Asset.Colors.popoverBgSelected.swiftUIColor : .clear)
                        .cornerRadius(8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            indexSelect = item.id ?? 0
                        }
                    }
                }
            }
            
        }
        
    }
    
}
 
