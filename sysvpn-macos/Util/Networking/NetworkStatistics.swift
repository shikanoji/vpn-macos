//
//  NetworkStatistics.swift
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

import Foundation

struct Bitrate : Equatable {
    var download: UInt32
    var upload: UInt32
    var time: Int = 0
    
    func rateString(for rate: UInt32) -> String {
        let rateString: String
        
        switch rate {
        case let rate where rate >= UInt32(pow(1024.0, 3)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 3)))gb/s"
        case let rate where rate >= UInt32(pow(1024.0, 2)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 2)))mb/s"
        case let rate where rate >= 1024:
            rateString = "\(String(format: "%.1f", Double(rate) / 1024.0))kb/s"
        default:
            rateString = "\(String(format: "%.1f", Double(rate)))b/s"
        }
        
        return rateString
    }
    
    static func ==(lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.upload == rhs.upload && lhs.download == rhs.download && lhs.time == rhs.time
    }
}

class NetworkStatistics {
    
    private struct NetworkTraffic {
        var downloadCount: UInt32 = 0
        var uploadCount: UInt32 = 0
        
        mutating func updateCountsByAdding(_ statistics: NetworkTraffic) {
            downloadCount = UInt32((UInt64(downloadCount) + UInt64(statistics.downloadCount)) % UInt64(UInt32.max))
            uploadCount = UInt32((UInt64(uploadCount) + UInt64(statistics.uploadCount)) % UInt64(UInt32.max))
        }
    }
    
    private var timer: Timer! = nil
    private var timeInterval: TimeInterval = 1
    private var traffic: NetworkTraffic! = nil
    private var updateWithBitrate: ((Bitrate) -> Void)?
    
    init(with timeInterval: TimeInterval, and updateHandler: @escaping (Bitrate) -> Void) {
        self.timeInterval = timeInterval
        updateWithBitrate = updateHandler
        
        traffic = getTrafficStatistics()
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateBitrate), userInfo: nil, repeats: true)
        updateBitrate()
    }
    
    func stopGathering() {
        timer.invalidate()
    }
    
    @objc private func updateBitrate() {
        guard let updateWithBitrate = updateWithBitrate else { return }
        
        let latestTraffic = self.getTrafficStatistics()
        let time = Int(Date.now.timeIntervalSince1970)
        // usage can overflow
        let bitrate = Bitrate(download: UInt32(TimeInterval(latestTraffic.downloadCount >= self.traffic.downloadCount
                                                            ? latestTraffic.downloadCount - self.traffic.downloadCount
                                                            : latestTraffic.downloadCount)
                                                            / timeInterval),
          upload: UInt32(TimeInterval(latestTraffic.uploadCount >= self.traffic.uploadCount
                                                          ? latestTraffic.uploadCount - self.traffic.uploadCount
                                                          : latestTraffic.uploadCount)
                                                          / timeInterval), time: time)
        
        self.traffic = latestTraffic
        
        updateWithBitrate(bitrate)
    }
    
    private func getTrafficStatistics() -> NetworkTraffic {
        let vpnTraffic = SystemDataUsage.vpnDataUsageInfo()
        return NetworkTraffic(downloadCount:  UInt32(vpnTraffic.received), uploadCount: UInt32(vpnTraffic.sent))
    }
    
    
}
