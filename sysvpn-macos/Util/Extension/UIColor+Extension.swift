//
//  UIColor+Extension.swift
//  sysvpn-macos
//
//  Created by doragon on 15/09/2022.
//

import Foundation
#if os(macOS)
    import AppKit
#elseif os(iOS)
    import UIKit
#elseif os(tvOS) || os(watchOS)
    import UIKit
#endif
#if canImport(SwiftUI)
    import SwiftUI
#endif

extension Color {
    init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
    
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, opacity: 1.0)
    }
  
    init(hexString: String, alpha: CGFloat = 1) {
        var cString: String = hexString.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
        if cString.hasPrefix("#") {
            cString.remove(at: cString.startIndex)
        }
    
        let scanner = Scanner(string: cString)
        scanner.scanLocation = 0
    
        var rgbValue: UInt64 = 0
    
        scanner.scanHexInt64(&rgbValue)
    
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
    
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, opacity: alpha
        )
    }
  
    init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
