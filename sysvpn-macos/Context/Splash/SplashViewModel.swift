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
            if DependencyContainer.shared.appStateMgr.sessionStartTime != nil {
                print("hasConnected")
            }
            
            OSExtensionManager.shared.onReady = {
                let ipc = IPCFactory.makeIPCRequestService()
                ipc.checkConnect {
                    DispatchQueue.main.async {
                        self.initData()
                    }
                }
                DispatchQueue.main.async {
                    DependencyContainer.shared.vpnManager.whenReady(queue: DispatchQueue.main) {
                        print("readdy")
                    }
                    
                    DependencyContainer.shared.vpnManager.prepareManagers(forSetup: true)
                }
            }
        }

       
        func initData() {
            if AppDataManager.shared.userSetting  == nil {
              _ =  AppDataManager.shared.loadSetupData {
                  self.onNext()
                }
            } else {
                onNext()
            }
        }
        
        func onStartApp() {
            if AppDataManager.shared.isLogin {
                NotificationCenter.default.post(name: .startJobUpdateCountry, object: nil)
            } else {
                NotificationCenter.default.post(name: .endJobUpdate, object: nil)
            }
        }
        
        
        func onNext() {
            if AppDataManager.shared.isLogin {
                OpenWindows.MainView.open()
            } else {
                OpenWindows.LoginView.open()
            }
            self.onStartApp()
        }
        
    }
}
