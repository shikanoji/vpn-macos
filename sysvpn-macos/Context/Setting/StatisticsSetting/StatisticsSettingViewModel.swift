//
//  StatisticsSettingViewModel.swift
//  sysvpn-macos
//
//  Created by doragon on 28/10/2022.
//

import Foundation

extension StatisticsSettingView {
    @MainActor class StatisticsSettingViewModel: ObservableObject {
        @Published var listItem: [StatisticsItem]
        
        init () {
            listItem = []
            let vpnStatus = StatisticsItem(settingType: L10n.Global.vpnStatus, settingContent: "VPN Status")
            let protocolUse = StatisticsItem(settingType: L10n.Global.protocolUse, settingContent: "OpenVPN")
            let currenSession = StatisticsItem(settingType: L10n.Global.currentSessionStr, settingContent: "2hr 30min 18sec")
            let currenIp = StatisticsItem(settingType: L10n.Global.currentIpStr, settingContent: "88.88.88.8.8888")
            let weeklyTime = StatisticsItem(settingType: L10n.Global.weeklyTimeStr, settingContent: "79 hr 55min 38sec")
            let longestConnection = StatisticsItem(settingType: L10n.Global.longestConnection, settingContent: "9hr 27min 59sec")
            listItem.append(vpnStatus)
            listItem.append(protocolUse)
            listItem.append(currenSession)
            listItem.append(currenIp)
            listItem.append(weeklyTime)
            listItem.append(longestConnection)
        }
    }
}


struct StatisticsItem: Identifiable {
    var id: UUID = UUID()
    var settingType: String
    var settingContent: String
}

