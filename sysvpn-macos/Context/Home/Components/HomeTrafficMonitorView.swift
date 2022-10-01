//
//  HomeTraficMonitorView.swift
//  sysvpn-macos
//
//  Created by NuocLoc on 01/10/2022.
//

import Foundation
import SwiftUI

struct HomeTrafficMonitorView : View {
    var body: some View {
        HStack (alignment: .top) {
            HomeTrafficInfoView()
            Spacer()
            HomeTrafficChartView()
                .frame(maxWidth: .infinity)
        }
    }
}

struct HomeTrafficInfoView : View {
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
                VStack (alignment: .trailing) {
                    Text("20:17:68")
                    Text("1.26 GB")
                    Text("421 MB")
                   
                }
            }
        }
        .font(Font.system(size: 13, weight: .regular))
        .foregroundColor(Color.white)
    }
}

struct HomeTrafficChartView : View {
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Text("Down Speed: 112 kB/s")
                }
                HStack {
                    Text("Up Speed: 112 kB/s")
                }
                Spacer()
            }
            Spacer().frame(height: 24)
            TrafficLineChartView()
        }
    }
}

struct HomeTraficMonitorView_Previews: PreviewProvider {

    static var previews: some View {
        HomeTrafficMonitorView()
    }
}
