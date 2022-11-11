//
//  StatisticsSettingView.swift
//  sysvpn-macos
//
//  Created by doragon on 27/10/2022.
//

import SwiftUI

struct StatisticsSettingView: View {
    @StateObject private var viewModel = StatisticsSettingViewModel()
    @EnvironmentObject private var appState: GlobalAppStates
    @EnvironmentObject private var mapState: MapAppStates
    var body: some View {
        VStack(alignment: .center) {
            HStack(alignment: .center) {
                VStack(alignment: .center, spacing: 24) {
                    ForEach(viewModel.listItem) { item in
                        HStack {
                            Text(item.settingType.name)
                                .foregroundColor(Color.white)
                                .font(Font.system(size: 14, weight: .regular))
                            Spacer()
                            Group {
                                switch item.settingType {
                                case .vpnStatus:
                                    StaticSettingItemValue(text: appState.displayState.rawValue)
                                case .currentIp:
                                    StaticSettingItemValue(text: appState.displayState == .connected ? (mapState.serverInfo?.ipAddress ?? "") : appState.userIpAddress)
                                case .vpnProtocol:
                                    StaticSettingItemValue(text: DependencyContainer.shared.vpnManager.currentVpnProtocol?.fullName ?? "")
                                case .currentSession:
                                    StaticSettingItemValue(text: getTime(now: Date().timeIntervalSince1970))
                                default:
                                    StaticSettingItemValue(text: "---")
                                }
                            }
                        }
                    }
                }
                .padding(30)
                .frame(width: 480)
                .background(Asset.Colors.headerSettingColor.swiftUIColor)
                .cornerRadius(16)
            }
        }
        .frame(maxWidth: .infinity, minHeight: 390)
    }
    
    func getTime(now: Double) -> String {
        guard let startTime = appState.sessionStartTime else {
            return "--:--:--"
        }
        
        let diff = now - startTime
        if diff < 0 {
            return "00:00:00"
        }
       
        let hour = floor(diff / 60 / 60)
        let min = floor((diff - hour * 60 * 60) / 60)
        let second = floor(diff - (hour * 60 * 60 + min * 60))
         
        return .init(format: "%02d:%02d:%02d", Int(hour), Int(min), Int(second))
    }
}

struct StaticSettingItemValue: View {
    var text: String
    var body: some View {
        Text(text)
            .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            .font(Font.system(size: 14, weight: .regular))
    }
}
 