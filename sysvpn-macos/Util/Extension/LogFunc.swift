//
//  LogFunc.swift
//  sysvpn-macos
//
//  Created by macbook on 07/11/2022.
//

import Foundation

public func print(items: Any..., separator: String = " ", terminator: String = "\n") {
    let output = items.map { "*\($0)" }.joined(separator: separator)
    #if DEBUG
        Swift.print(output, terminator: terminator)
    #endif
}
