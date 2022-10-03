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
        }
        
        func loadAppSetting() {
           _ = APIServiceManager.shared.getAppSetting().subscribe { event in
                OpenWindows.LoginView.open()
                switch event {
                case let .success(response):
                    AppDataManager.shared.saveIpInfo(info: response.ipInfo)
                case let .failure(e):
                    guard let error = e as? ResponseError else {
                        return
                    }
                    print(error)
                }
            }
        }
    }
}
