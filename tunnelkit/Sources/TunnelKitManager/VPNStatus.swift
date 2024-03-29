//
//  VPNStatus.swift
//  TunnelKit
//
//  Created by Davide De Rosa on 9/18/18.
//  Copyright (c) 2022 Davide De Rosa. All rights reserved.
//
//  https://github.com/passepartoutvpn
//
//  This file is part of TunnelKit.
//
//  TunnelKit is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  TunnelKit is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with TunnelKit.  If not, see <http://www.gnu.org/licenses/>.
//

import Foundation

/// Status of a `VPN`.
public enum VPNStatus: String {
    /// VPN is connected.
    case connected
    
    /// VPN is attempting a connection.
    case connecting
    
    /// VPN is disconnected.
    case disconnected
    
    /// VPN is completing a disconnection.
    case disconnecting
}
