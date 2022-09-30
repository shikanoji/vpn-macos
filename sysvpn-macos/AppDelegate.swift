//
//  AppDelegate.swift
//  sysvpn-macos
//
//  Created by Nguyen Dinh Thach on 30/08/2022.
//

import AppKit
import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_: Notification) {
        //
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(test), userInfo: nil, repeats: true)
    }
    
    @objc func test() {
        var send = SystemDataUsage.getDataUsage().wifiSent
        var revc = SystemDataUsage.getDataUsage().wifiReceived
        print("\(send) \(revc)")
    }
}
