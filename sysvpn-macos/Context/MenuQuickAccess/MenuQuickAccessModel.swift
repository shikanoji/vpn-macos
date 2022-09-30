//
//  MenuQuickAccessModel.swift
//  sysvpn-macos
//
//  Created by doragon on 30/09/2022.
//

import Foundation
import SwiftUI

extension MenuQuickAccessView {
    @MainActor class MenuQuickAccessModel: ObservableObject {
        @Published var userIp: String = ""
        @Published var location: String = ""
         
        init() {
            userIp = "IP: \(AppDataManager.shared.userIp)"
            location = "Location: \(AppDataManager.shared.userCity)"
        }
    }
}

class MenuQuickAccessConfigurator {
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var mainView: NSView
    private var visualEffect = NSVisualEffectView()
    
    init() {
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .underWindowBackground
        visualEffect.frame = NSRect(x: 0, y: 0, width: 400, height: 580)
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.squareLength)
        mainView = NSHostingView(rootView: MenuQuickAccessView())
        mainView.frame = visualEffect.frame
        visualEffect.addSubview(mainView)
        createMenu()
    }
    
    func createMenu() {
        if let statusBarButton = statusItem.button {
            let mainMenu = NSMenu()
            statusBarButton.image = Asset.Assets.icLogoWhite.image
            statusBarButton.frame = NSRect(x: 0, y: 0, width: 30, height: 30)
            let rootItem = NSMenuItem()
            rootItem.target = self
            rootItem.view = visualEffect
            mainMenu.addItem(rootItem)
            statusItem.menu = mainMenu
        }
    }
}
