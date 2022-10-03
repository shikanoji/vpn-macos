//
//  sysvpn_macosApp.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 29/08/2022.
//

import SwiftUI

@main
struct sysvpn_macosApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var windowMgr = WindowMgr.shared
    @State private var spashWindow: NSWindow?
    var body: some Scene {
        WindowGroup(id: "main") {
            if windowMgr.currentWindow == .SpashView {
                SplashView().frame(width: 300, height: 300, alignment: .center)
                    .background(WindowAccessor(window: $spashWindow))
                     
            } else if WindowMgr.shared.currentWindow == .LoginView {
                LoginView().frame(width: 500, height: 770, alignment: .center)
                    .withHostingWindow { window in
                    if let window = window {
                        window.styleMask = [.titled, .fullSizeContentView, .borderless, .closable, .miniaturizable]
                        window.standardWindowButton(.zoomButton)?.isHidden = true
                        window.backgroundColor = Asset.Colors.mainBackgroundColor.color
                    }
                }
            } else if WindowMgr.shared.currentWindow == .MainView {
                HomeView().withHostingWindow { window in
                    if let window = window {
                        window.styleMask = [.titled, .fullSizeContentView, .closable, .miniaturizable, .resizable ]
                        window.backgroundColor = Asset.Colors.mainBackgroundColor.color
                        window.isMovableByWindowBackground = false
                        window.standardWindowButton(.zoomButton)?.isHidden = false
                    }
                }.environmentObject(GlobalAppStates.shared)
            }
        }.windowStyle(HiddenTitleBarWindowStyle())
            .commands {
                CommandGroup(replacing: .newItem, addition: {
                    
                })
            }
            .handlesExternalEvents(matching: ["main"])
        
    }
}
