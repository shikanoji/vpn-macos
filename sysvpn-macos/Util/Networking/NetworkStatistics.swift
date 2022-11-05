//
//  NetworkStatistics.swift
//  sysvpn-macos
//
//  Created by macbook on 17/10/2022.
//

import Foundation

struct Bitrate: Equatable {
    var download: UInt32
    var upload: UInt32
    var time: Int = 0
    
    static func rateString(for rate: UInt32) -> String {
        let rateString: String
        
        switch rate {
        case let rate where rate >= UInt32(pow(1024.0, 3)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 3))) GB/s"
        case let rate where rate >= UInt32(pow(1024.0, 2)):
            rateString = "\(String(format: "%.1f", Double(rate) / pow(1024.0, 2))) MB/s"
        case let rate where rate >= 1024:
            rateString = "\(String(format: "%.1f", Double(rate) / 1024.0)) KB/s"
        default:
            rateString = "\(String(format: "%.1f", Double(rate))) B/s"
        }
        
        return rateString
    }
    
    static func == (lhs: Bitrate, rhs: Bitrate) -> Bool {
        return lhs.upload == rhs.upload && lhs.download == rhs.download && lhs.time == rhs.time
    }
}

class NetworkStatistics {
    private struct NetworkTraffic {
        var downloadCount: UInt64 = 0
        var uploadCount: UInt64 = 0
    }
     
    private var timer: Timer!
    private var timeInterval: TimeInterval = 0.1
    private var traffic: NetworkTraffic!
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
        
        let latestTraffic = getTrafficStatistics()
        let time = Int(Date.now.timeIntervalSince1970)
        // usage can overflow
        let bitrate = Bitrate(download: UInt32(TimeInterval(latestTraffic.downloadCount >= traffic.downloadCount
                ? latestTraffic.downloadCount - traffic.downloadCount
                : latestTraffic.downloadCount)
            / timeInterval),
        upload: UInt32(TimeInterval(latestTraffic.uploadCount >= traffic.uploadCount
                ? latestTraffic.uploadCount - traffic.uploadCount
                : latestTraffic.uploadCount)
            / timeInterval), time: time)
        
        traffic = latestTraffic
      
        updateWithBitrate(bitrate)
    }
    
    private func getTrafficStatistics() -> NetworkTraffic {
        let vpnTraffic = SystemDataUsage.vpnDataUsageInfo()
        return NetworkTraffic(downloadCount:  vpnTraffic.received, uploadCount: vpnTraffic.sent)
    }
}

public struct LastNItemsBuffer {
    var array: [Double?]
    private var index = 0

    public init(count: Int) {
        array = [Double?](repeating: nil, count: count)
    }

    public mutating func clear() {
        forceToValue(value: nil)
    }

    public mutating func forceToValue(value: Double?) {
        let count = array.count
        array = [Double?](repeating: value, count: count)
    }

    public mutating func write(_ element: Double) {
        array[index % array.count] = element
        index += 1
    }

    public func lastNItems() -> [Double] {
        var result = [Double?]()
        for loop in 0..<array.count {
            result.append(array[(loop + index) % array.count])
        }
        return result.compactMap { $0 }
    }
    
    var last: Double? {
        
        return array[(index + array.count - 1) % array.count]
    }
     
    public func max() -> Double? {
        return array.max { a, b in
            return (a ?? 0) > (b ?? 0)
        } ?? 0
    }
    
    public mutating func anim(to value: Double = 0, speed: Double = 1024) -> Bool {
        var last = array[(Swift.max(0, index - 1)) % array.count] ?? 0
        //   var abs = Swift.max(10, abs(value - last) / 3);
        if last >= value {
            last = Swift.max(value, last - speed)
        } else if last < value {
            last = Swift.min(value, last + speed)
        }
        write(last)
        return speed > 0 && last == value
    }
}
