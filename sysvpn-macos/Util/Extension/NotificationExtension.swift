//
//  NotificationExtension.swift
//  sysvpn-macos
//
//  Created by doragon on 19/10/2022.
//

import Foundation

extension Notification.Name {
    static let startJobUpdateCountry = NSNotification.Name("startJobUpdateCountry")
    static let endJobUpdate = NSNotification.Name("endJobUpdate")
    static let updateCountry = NSNotification.Name("updateCountry")
    static let updateMultipleHop = NSNotification.Name("updateMultipleHop")
    static let reloadServerStar = NSNotification.Name("reloadServerStar")
    static let needUpdateServerInfo = NSNotification.Name("needUpdateServerInfo")
    static let appReadyStart = NSNotification.Name("appReadyStart")
}
