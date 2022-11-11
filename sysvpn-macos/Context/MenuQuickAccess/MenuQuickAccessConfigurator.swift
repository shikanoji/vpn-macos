//
//  MenuQuickAccessConfig.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI
 
class MenuQuickAccessConfigurator {
    static var shared: MenuQuickAccessConfigurator!
    private var statusBar: NSStatusBar
    private var statusItem: NSStatusItem
    private var mainView: NSView
    private var visualEffect = NSVisualEffectView()
    private var popover: NSPopover

    init() {
        visualEffect.blendingMode = .behindWindow
        visualEffect.state = .active
        visualEffect.material = .underWindowBackground
        visualEffect.frame = NSRect(x: 0, y: 0, width: 400, height: 580)
        statusBar = NSStatusBar.system
        statusItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)
        mainView = NSHostingView(rootView: MenuQuickAccessView())
        mainView.frame = visualEffect.frame
        //  visualEffect.addSubview(mainView)
       
        let popover = NSPopover()
        popover.contentSize = NSSize(width: 400, height: 580)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: MenuQuickAccessView()
            .environmentObject(GlobalAppStates.shared)
            .environmentObject(NetworkAppStates.shared)
        )
        
        self.popover = popover
        
        createMenu()
        MenuQuickAccessConfigurator.shared = self
    }
    
    func createMenu() {
        if let statusBarButton = statusItem.button {
            //  let mainMenu = NSMenu()
            statusBarButton.image = Asset.Assets.icLogoWhite.image
            // statusBarButton.frame = NSRect(x: 0, y: 0, width: 30, height: 30)
            /* let rootItem = NSMenuItem()
             rootItem.target = self
             rootItem.view = visualEffect
             mainMenu.addItem(rootItem)
             statusItem.menu = mainMenu*/
            statusBarButton.target = self
            statusBarButton.action = #selector(MenuQuickAccessConfigurator.togglePopover(_:))
        }
    }
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if let statusBarButton = statusItem.button {
            if popover.isShown {
                popover.performClose(sender)
            } else {
                popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.minY)
                popover
                    .contentViewController?
                    .view.window?
                    .makeKey()
            }
        }
    }
     
    class func closePopover() {
        MenuQuickAccessConfigurator.shared.popover.performClose(nil)
    }
    
    func show() {
        if let statusBarButton = statusItem.button {
            statusBarButton.isHidden = false
        }
    }

    func hide() {
        if let statusBarButton = statusItem.button {
            statusBarButton.isHidden = true
        }
    }
}
