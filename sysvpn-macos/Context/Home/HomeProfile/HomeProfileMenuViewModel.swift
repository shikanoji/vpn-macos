//
//  HomeProfileMenuViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/11/2022.
//

import Foundation
import Combine

extension HomeProfileMenuView {
    
    @MainActor class HomeProfileMenuViewModel: ObservableObject { 
        @Published var test = [1,2,3]
        @Published var listShow: [UserProfileTemp]
        var changeSink: AnyCancellable?
        init() {
            listShow = []
            loadData()
            listen()
        }
        
        func loadData () {
            listShow = []
            if GlobalAppStates.shared.listProfile.isEmpty {
                AppDataManager.shared.readListProfile()
            }
            let listProfile = GlobalAppStates.shared.listProfile
            
            if listProfile.count >= 3{
                listShow.append(listProfile[0])
                listShow.append(listProfile[1])
                listShow.append(listProfile[2])
            } else {
                listShow = listProfile
            }
        }
        
        func listen(){
            changeSink = GlobalAppStates.shared.$listProfile.sink { listProfile in
                self.listShow = []
                if listProfile.count >= 3 {
                    self.listShow.append(listProfile[0])
                    self.listShow.append(listProfile[1])
                    self.listShow.append(listProfile[2])
                } else {
                    self.listShow = listProfile
                }
            }
    
        }
        
        func onCreateProfile() {
            
        }
    }
    
}



