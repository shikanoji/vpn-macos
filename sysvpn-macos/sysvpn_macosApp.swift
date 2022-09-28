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
    var body: some Scene {
       /* WindowGroup {
            LoginView().frame(width: 500, height: 770, alignment: .center)
            // VpnMapView().frame(width: 1024, height: 588, alignment: .center)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(arrayLiteral:OpenWindows.LoginView.rawValue))
        */
        WindowGroup("MainWindow") {
            VpnMapView().frame(width: 1024, height: 588, alignment: .center)
        }
        .windowStyle(HiddenTitleBarWindowStyle())
        .handlesExternalEvents(matching: Set(arrayLiteral:OpenWindows.MainView.rawValue))
       
    }
}
