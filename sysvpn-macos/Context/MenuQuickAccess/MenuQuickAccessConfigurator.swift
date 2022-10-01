//
//  MenuQuickAccessConfig.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI
 
class MenuQuickAccessConfigurator {
    
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
        popover.contentViewController = NSHostingController(rootView: MenuQuickAccessView().environmentObject(GlobalAppStates.shared))
        
        self.popover = popover
        
        createMenu()
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

            if self.popover.isShown {
                self.popover.performClose(sender)
            } else {
                self.popover.show(relativeTo: statusBarButton.bounds, of: statusBarButton, preferredEdge: NSRectEdge.minY)
            }
        }
    }
     

    class func closePopover() {
      
        guard let appDelegate = NSApp.delegate as? AppDelegate else {
            return
        }
        print("closeedd")
        appDelegate.menuExtrasConfigurator?.popover.performClose(nil)
    }
}
