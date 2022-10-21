//
//  SplashViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 29/09/2022.
//

import Foundation
import SwiftUI

extension SplashView {
    @MainActor class SplashViewModel: ObservableObject {
        @Published var outLightSize: CGFloat = 300
        @Published var logoSize = CGSize(width: 100, height: 116)

        init() {
            loadAppSetting()
            onStartApp()
        }
        
        func onStartApp() {
            if AppDataManager.shared.isLogin {
                NotificationCenter.default.post(name: .startJobUpdateCountry, object: nil)
            } else {
                NotificationCenter.default.post(name: .endJobUpdate, object: nil)
            }
        }
        
        func loadAppSetting() {
           _ = APIServiceManager.shared.getAppSetting().subscribe { event in
               if AppDataManager.shared.isLogin {
                   self.loadCountry()
               } else {
                   OpenWindows.LoginView.open()
               }
                
                switch event {
                case let .success(response):
                    AppDataManager.shared.saveIpInfo(info: response.ipInfo)
                    AppDataManager.shared.userSetting = response
                    AppDataManager.shared.lastChange = response.lastChange ?? 0
                case let .failure(e):
                    guard let error = e as? ResponseError else {
                        return
                    }
                    print(error)
                }
            }
        }
        
        func loadCountry() {
            _ = APIServiceManager.shared.getListCountry().subscribe({ result in
                switch result {
                case let .success(response):
                    AppDataManager.shared.userCountry = response
                    OpenWindows.MainView.open()
                case .failure(_):
                    break
                }
            })
        }
    }
}
