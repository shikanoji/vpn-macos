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
        
        init() {
            listItem = []
            let vpnStatus = StatisticsItem(settingType: .vpnStatus)
            let protocolUse = StatisticsItem(settingType: .vpnProtocol)
            let currenSession = StatisticsItem(settingType: .currentSession)
            let currenIp = StatisticsItem(settingType: .currentIp)
            let weeklyTime = StatisticsItem(settingType: .weeklyTime)
            let longestConnection = StatisticsItem(settingType: .longestConnection)
           
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
    var id: UUID = .init()
    var settingType: StatisticSettingType
}

enum StatisticSettingType {
    case vpnStatus
    case vpnProtocol
    case currentSession
    case currentIp
    case weeklyTime
    case longestConnection
    
    var name: String {
        switch self {
        case .currentIp:
            return L10n.Global.currentIpStr
        case .currentSession:
            return L10n.Global.currentSessionStr
        case .longestConnection:
            return L10n.Global.longestConnection
        case .vpnProtocol:
            return L10n.Global.vpnSetting
        case .vpnStatus:
            return L10n.Global.vpnStatus
        case .weeklyTime:
            return L10n.Global.weeklyTimeStr
        }
    }
}
