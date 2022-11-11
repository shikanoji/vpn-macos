//
//  HomeListCountryNodeView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import Kingfisher
import SwiftUI

struct HomeListCountryNodeView: View {
    @Binding var selectedItem: HomeMenuItem
    @Binding var countries: [HomeListCountryModel]
    @Binding var isShowCity: Bool
    @Binding var countrySelected: HomeListCountryModel?
    var onTouchItem: ((INodeInfo) -> Void)?
    var body: some View {
        VStack(alignment: .leading) {
            List(countries) { item in
                switch item.type {
                case .spacing:
                    Spacer().frame(height: 30)
                case .country:
                    if selectedItem == .manualConnection {
                        CountryItemView(countryName: item.title, imageUrl: item.imageUrl, totalCity: item.totalCity)
                            .onTapGesture {
                                if item.totalCity > 1 {
                                    isShowCity = true
                                    countrySelected = item
                                } else {
                                    guard let origin = item.origin else {
                                        return
                                    }
                                    onTouchItem?(origin)
                                }
                            }
                            .transaction { transaction in
                                transaction.animation = nil
                            }
                    } else if selectedItem == .staticIp {
                        StaticItemView(countryName: item.title, cityName: item.cityName, imageUrl: item.imageUrl, serverNumber: item.serverNumber, percent: item.serverStar)
                            .transaction { transaction in
                                transaction.animation = nil
                            }.onTapGesture {
                                guard let origin = item.origin else {
                                    return
                                }
                                onTouchItem?(origin)
                            }
                    } else if selectedItem == .multiHop {
                        MultiHopItemView(countryNameStart: item.title, countryNameEnd: item.title2, imageUrlStart: item.imageUrl, imageUrlEnd: item.imageUrl2)
                            .transaction { transaction in
                                transaction.animation = nil
                            }
                            .onTapGesture {
                                guard let origin = item.origin else {
                                    return
                                }
                                onTouchItem?(origin)
                            }
                    }
                case .header:
                    if selectedItem == .manualConnection || selectedItem == .multiHop {
                        VStack {
                            Text(item.title)
                                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                                .font(Font.system(size: 14, weight: .regular))
                            Spacer().frame(height: 21)
                        }
                    } else if selectedItem == .staticIp {
                        HStack {
                            Text(item.title)
                                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
                                .font(Font.system(size: 14, weight: .regular))
                            Spacer()
                            Text("CURRENT LOAD")
                                .foregroundColor(Asset.Colors.primaryColor.swiftUIColor)
                                .font(Font.system(size: 11, weight: .medium))
                        }.padding(.bottom, 16)
                    }
                }
            }
            .modifier(ListViewModifier()) 
            .id(UUID())
        }
        .padding(.horizontal, 6)
        .frame(width: 300, alignment: .leading)
        .background(Asset.Colors.backgroundColor.swiftUIColor)
    }
}

struct HomeDetailCityNodeView: View {
    @Binding var selectedItem: HomeMenuItem
    @Binding var listCity: [HomeListCountryModel]
    @Binding var isShowCity: Bool
    var countryItem: HomeListCountryModel?
    var onTouchItem: ((INodeInfo) -> Void)?
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .center) {
                Asset.Assets.icArrowLeft.swiftUIImage
                    .resizable()
                    .frame(width: 24, height: 24)
                if countryItem?.imageUrl != nil {
                    KFImage(URL(string: (countryItem?.imageUrl!)!))
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(16)
                } else {
                    Asset.Assets.icFlagEmpty.swiftUIImage
                        .resizable()
                        .frame(width: 24, height: 24)
                        .cornerRadius(16)
                }
                Text(countryItem?.title ?? "")
                    .foregroundColor(Color.white)
                    .font(Font.system(size: 16, weight: .semibold))
            }
            .contentShape(Rectangle())
            .onTapGesture {
                isShowCity = false
            }
            List(listCity) { item in
                CityItemView(countryName: countryItem?.title ?? "", cityName: item.title, imageUrl: item.imageUrl)
                    .transaction { transaction in
                        transaction.animation = nil
                    }
                    .onTapGesture {
                        guard let origin = item.origin else {
                            return
                        }
                        onTouchItem?(origin)
                    }
            }
            .modifier(ListViewModifier())
        }
        .padding(.horizontal, 6)
        .frame(width: 300, alignment: .leading)
        .background(Asset.Colors.backgroundColor.swiftUIColor)
    }
}

struct HomeListWraperView: ViewModifier {
    var onClose: (() -> Void)?
    
    func body(content: Content) -> some View {
        content
            .background(Asset.Colors.backgroundColor.swiftUIColor)
            .overlay {
                Asset.Assets.icClose.swiftUIImage.padding(10)
                    .background(Asset.Colors.backgroundColor.swiftUIColor)
                    .position(x: 315, y: 0)
                    .allowsHitTesting(true)
                    .onTapGesture {
                        withAnimation {
                            onClose?()
                        }
                    }
            }
            .transition(
                AnyTransition.asymmetric(
                    insertion: .move(edge: .leading),
                    removal: .move(edge: .leading)
                ).combined(with: .opacity))
    }
}
  
enum HomeListCountryModelType {
    case header
    case country
    case spacing
}

struct HomeListCountryModel: Identifiable, Equatable {
    static func == (lhs: HomeListCountryModel, rhs: HomeListCountryModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    var id = UUID()
    var type: HomeListCountryModelType
    var title: String = ""
    var totalCity: Int = 0
    var imageUrl: String?
    var cityName: String = ""
    var serverNumber: Int = 0
    var serverStar: Int = 1
    var idCountry: Int = 0
    var title2: String = ""
    var imageUrl2: String?
    var origin: INodeInfo?
}

struct ListViewModifier: ViewModifier {
    @ViewBuilder
    func body(content: Content) -> some View {
        content
    }
}
