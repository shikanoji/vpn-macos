//
//  SpashWindowAccessor.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 30/09/2022.
//

import Foundation
import SwiftUI

struct WindowAccessor: NSViewRepresentable {
    @Binding var window: NSWindow?
    
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async {
            self.window = view.window
         
            window?.styleMask = [.titled, .fullSizeContentView, .borderless]
            window?.titleVisibility = .hidden
            window?.backingType = .buffered
            window?.isMovableByWindowBackground = true
            window?.titlebarSeparatorStyle = .none
            window?.titlebarAppearsTransparent = true
            window?.isOpaque = true
            window?.backgroundColor = NSColor.clear
            window?.showsToolbarButton = false 

        }
        
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}

extension View {
    public func withHostingWindow(_ callback: @escaping (NSWindow?) -> Void) -> some View {
        self.background(HostingWindowFinder(callback: callback))
    }
}

struct HostingWindowFinder: NSViewRepresentable {
    var callback: (NSWindow?) -> ()
 
    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        DispatchQueue.main.async { [weak view] in
            self.callback(view?.window)
        }
        return view
    }
    
    func updateNSView(_ nsView: NSView, context: Context) {}
}
