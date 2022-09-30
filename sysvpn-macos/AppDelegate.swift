//
//  AppDelegate.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 30/08/2022.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    private var menuExtrasConfigurator: MenuQuickAccessConfigurator?
    
    func applicationDidFinishLaunching(_: Notification) {
        //
        menuExtrasConfigurator = .init()
    }
}
