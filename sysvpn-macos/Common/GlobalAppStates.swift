//
//  GlobalAppState.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 02/10/2022.
//

import Foundation


class GlobalAppStates: ObservableObject {
    static let shared = GlobalAppStates()
    @Published var displayState: AppDisplayState = .disconnected
    @Published var bitRate: Bitrate =  Bitrate(download: 0, upload: 0)
    @Published var connectedNode: INodeInfo? = nil
    @Published var selectedNode:  INodeInfo? = nil
    @Published var hoverNode: NodePoint? = nil
    @Published var serverInfo: VPNServer? = nil
}
