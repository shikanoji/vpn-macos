//
//  SplashViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 29/09/2022.
//

import Foundation

 

extension SplashView {
    @MainActor class SplashViewModel: ObservableObject {
        @Published var outLightSize: CGFloat = 300
        @Published var logoSize = CGSize(width: 100, height: 116)

        init() {
            loadAppSetting()
        }
        
        func loadAppSetting() {
            APIServiceManager.shared.getAppSetting().subscribe { event in
                switch event {
                case .success(let response) :
                    AppDataManager.shared.saveIpInfo(info: response.ipInfo)
                case .failure( let e):
                    guard let error = e as? ResponseError else {
                        return
                    }
                    //handel fail
                    error.message
                }
            }
        }
         
    }
}
