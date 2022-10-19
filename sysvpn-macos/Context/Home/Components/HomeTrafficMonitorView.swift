//
//  HomeTraficMonitorView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI

struct HomeTrafficMonitorView : View {
    @State var bitRateState = Bitrate(download: 0, upload: 0)
    @State var usageInfo = SingleDataUsageInfo(received: 0, sent: 0)
    @EnvironmentObject var appState: GlobalAppStates
    var body: some View {
        HStack (alignment: .top) {
            HomeTrafficInfoView(bitRate: bitRateState, usageInfo: usageInfo)
            Spacer()
            HomeTrafficChartView(bitRate: bitRateState)
                .frame(maxWidth: .infinity)
        } .onChange(of: appState.bitRate) { newValue in
            bitRateState = newValue
            usageInfo = SystemDataUsage.lastestVpnUsageInfo
        }
    }
}

struct HomeTrafficInfoView : View {
    var bitRate: Bitrate
    var usageInfo: SingleDataUsageInfo
    
    var body: some View {
        VStack (alignment: .leading) {
            Text("Sesion Traffic")
                .font(Font.system(size: 16, weight: .semibold))
                .foregroundColor(Asset.Colors.subTextColor.swiftUIColor)
            Spacer().frame(height: 15)
            HStack (alignment: .top) {
                VStack (alignment: .leading){
                    Text("Session:")
                    Text("Down Volume:")
                    Text("Up Volume:")
                }
                Spacer()
                VStack (alignment: .trailing) {
                    Text("20:17:68")
                    Text(usageInfo.displayString(for: usageInfo.received))
                    Text(usageInfo.displayString(for: usageInfo.sent))
                   
                }
            }.frame(maxWidth: 200)
        }
        .font(Font.system(size: 13, weight: .regular))
        .foregroundColor(Color.white)
    }
}

struct HomeTrafficChartView : View {
    var bitRate: Bitrate
    @State var lineDownSpeed:[Double] = [0]
    @State var lineUpSpeed:[Double] = [0]
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("Down Speed: \(bitRate.rateString(for: bitRate.download))")
                }
                HStack {
                    Text("Up Speed: \(bitRate.rateString(for: bitRate.upload))")
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            TrafficLineChartView()
        }.onChange(of: bitRate) { newValue in
            withAnimation {
                lineDownSpeed.append(Double(bitRate.download))
                lineUpSpeed.append(Double(bitRate.upload))
                if lineDownSpeed.count > 20 {
                    lineDownSpeed.removeFirst()
                }
                if lineUpSpeed.count > 20 {
                    lineUpSpeed.removeFirst()
                }
            }
        }
    }
}

struct HomeTraficMonitorView_Previews: PreviewProvider {

    static var previews: some View {
        HomeTrafficMonitorView()
    }
}
