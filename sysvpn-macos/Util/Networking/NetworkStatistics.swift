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
    
   static func rateString(for rate: UInt32) -> String {
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
    
    var downloadHistory : LastNItemsBuffer =  LastNItemsBuffer(count: 30);
    var uploadHistory : LastNItemsBuffer =  LastNItemsBuffer(count: 30);
    var latestBitrateInfo: [Bitrate] = [Bitrate(download: 0, upload: 0, time: 0)]
 
    private var timer: Timer! = nil
    private var timer2: Timer! = nil
    private var timeInterval: TimeInterval = 1
    private var timeIntervalGraph: TimeInterval = 0.2
    private var traffic: NetworkTraffic! = nil
    private var updateWithBitrate: ((Bitrate) -> Void)?
    
    
    
    init(with timeInterval: TimeInterval, and updateHandler: @escaping (Bitrate) -> Void) {
        self.timeInterval = timeInterval
        updateWithBitrate = updateHandler
        
        traffic = getTrafficStatistics()
        
        timer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateBitrate), userInfo: nil, repeats: true)
        
        timer2 = Timer.scheduledTimer(timeInterval: timeIntervalGraph, target: self, selector: #selector(updateHistory), userInfo: nil, repeats: true)
        
        updateBitrate()
    }
    
    func stopGathering() {
        timer2.invalidate()
        timer.invalidate()
    }
    
    @objc private func updateHistory() {
        var value =  Double(latestBitrateInfo.first?.download ?? 0);
        var value2 =  Double(latestBitrateInfo.first?.upload ?? 0)
        var speed1: Double = 0;
        var speed2: Double = 0;
        if latestBitrateInfo.count > 1 {
            speed1 = abs(Double(latestBitrateInfo[1].download) - Double(latestBitrateInfo[0].download)) / 3
            speed2 = abs(Double(latestBitrateInfo[1].upload) - Double(latestBitrateInfo[0].upload)) / 3
            
            value = Double(latestBitrateInfo[1].download)
            value2 = Double(latestBitrateInfo[1].upload)
            if speed1 == 0 && speed1 == speed2 {
                latestBitrateInfo.removeFirst()
                return
            }

        }
         
        let onDoneAnim = {
            self.latestBitrateInfo.removeFirst()
            let value =  Double(self.latestBitrateInfo.first?.download ?? 0);
            let value2 =  Double(self.latestBitrateInfo.first?.upload ?? 0)
            self.downloadHistory.write(value)
            self.uploadHistory.write(value2)
        }
        
        if  downloadHistory.anim(to: value, speed:   speed1 ){
            
            if latestBitrateInfo.count > 1 && speed2 < speed1 {
              
                onDoneAnim()
            }
        }
        if uploadHistory.anim(to: value2, speed:   speed2 ) {
           if latestBitrateInfo.count > 1 && speed2 >= speed1 {
               onDoneAnim()
            }
        }
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
           
        self.latestBitrateInfo.append(bitrate)
        
        updateWithBitrate(bitrate)
    }
    
    private func getTrafficStatistics() -> NetworkTraffic {
        let vpnTraffic = SystemDataUsage.vpnDataUsageInfo()
        return NetworkTraffic(downloadCount:  UInt32(vpnTraffic.received), uploadCount: UInt32(vpnTraffic.sent))
    }
    
    
}


public struct LastNItemsBuffer {
    var array: [Double?]
    fileprivate var index = 0

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
            result.append(array[(loop+index) % array.count])
        }
        return result.compactMap { $0 }
    }
     
    public func max() -> Double? {
        return array.max { a, b in
            return (a ?? 0) > (b ?? 0)
        } ?? 0
    }
    
    public mutating func anim(to value: Double = 0, speed: Double = 1024) -> Bool{
        var last = (array[(Swift.max(0, index - 1)) % array.count] ) ?? 0
     //   var abs = Swift.max(10, abs(value - last) / 3);
        if last >= value {
            last = Swift.max(value , last - speed)
        } else if last < value {
            last = Swift.min(value , last + speed)
        }
        write(last )
        return speed > 0 && last == value
    }
}
