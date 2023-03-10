//
//  LogFunc.swift
//  sysvpn-macos
//
//  Created by macbook on 07/11/2022.
//

import Foundation

public func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    #if DEBUG
        let output = items.map { "*\($0)" }.joined(separator: separator)
        Swift.print(output, terminator: terminator)
    #endif
}
