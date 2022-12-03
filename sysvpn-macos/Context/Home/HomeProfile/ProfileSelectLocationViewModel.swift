//
//  ProfileSelectLocationViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 29/11/2022.
//

import Foundation

extension ProfileSelectLocationView {
    @MainActor class ProfileSelectLocationViewModel: ObservableObject {
        @Published var listCountry: [CountryAvailables]
        @Published var searchInput: String = ""
        @Published var profileInput: String = ""
        @Published var serverId: Int = 0
        @Published var isShowErrorEmptyName: Bool = false
        @Published var isShowErrorEmptyCountry: Bool = false
        
        @Published var itemEdit: UserProfileTemp?
        
        init() {
            listCountry = []
            getListCountry()
            serverId = itemEdit?.serverId ?? 0
        }
        
        
        func getListCountry() {
            listCountry = AppDataManager.shared.userCountry?.availableCountries ?? []
        }
        
        func onEdit(onComplete: (() -> Void)?) {
            print("ITEM EDIT: \(itemEdit?.serverId)")
            onComplete?()
        }
        
        func onCreate(  onComplete: (() -> Void)?) {
            if profileInput == "" || profileInput.isEmpty {
                isShowErrorEmptyName = true
                isShowErrorEmptyCountry = false
                return
            } else if serverId == 0 {
                isShowErrorEmptyName = false
                isShowErrorEmptyCountry = true
                return
            } else {
                isShowErrorEmptyName = false
                isShowErrorEmptyCountry = false
                
                if GlobalAppStates.shared.listProfile.isEmpty {
                    AppDataManager.shared.readListProfile()
                }
                
                var item = UserProfileTemp()
                item.profileName = profileInput
                item.serverId = serverId
                item.profileId = UUID()
                
                GlobalAppStates.shared.listProfile.insert(item, at: 0)
                AppDataManager.shared.saveProfile()
                onComplete?()
            }
             
        }
    }
}
