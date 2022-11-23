//
//  NetworkChecker.swift
//  sysvpn-macos
//
//  Created by macbook on 22/11/2022.
//

import Foundation


class NetworkChecker {
    static let shared = NetworkChecker()
    let kSaveUserDefaulTime = "klastRefreshByPingTime"
    let kSaveUserRetryLastTime = "kSaveUserRetryLastTime"
    let ipCheckInternet = "8.8.8.8"
    let ipCheckInternetSecond = "1.1.1.1"
    
    var internetPinger: SwiftyPing?
    
    var timerPingInternet: Timer?
    var pingInternetTimeout: Double = 10
    var flagLostInternet = false
    var flagIsRertryConnect  = false
    
    var retryTime = 0
    
    var lastRetryTime: Double {
        get {
            return UserDefaults.standard.double(forKey: kSaveUserRetryLastTime)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: kSaveUserRetryLastTime)
            UserDefaults.standard.synchronize()
        }
    }
    var lastRefreshByPingTime: Double {
        get {
            return UserDefaults.standard.double(forKey: kSaveUserDefaulTime)
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: kSaveUserDefaulTime)
            UserDefaults.standard.synchronize()
        }
    }
    
    func checkInternet() {
        internetPinger = try? SwiftyPing(host: ipCheckInternet, configuration: PingConfiguration(interval: 1, with: pingInternetTimeout), queue: DispatchQueue.global())
        internetPinger?.observer = pingInternetResponse
      
        
        internetPinger?.targetCount = 1
        try? internetPinger?.startPinging()
        timerPingInternet = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(doPing), userInfo: internetPinger, repeats: true)
       
    }
    
    func pingInternetResponse(_ response: PingResponse) {
        let duration = response.duration
        print(duration)
        if GlobalAppStates.shared.displayState != AppDisplayState.connected {
            print("[NetworkChecker] abort by disconnected")
            return
        }
        
        if duration < pingInternetTimeout &&  response.error == nil {
            checkRetryLostInternetConnect()
            print("[NetworkChecker] abort by pingInternetTimeout")
            return
        }
        
        if flagIsRertryConnect {
            print("[NetworkChecker] abort by flagIsRertryConnect ")
            return
        }
        
        if SystemDataUsage.hadCanGetAppNetworkInterface && !SystemDataUsage.canGetAppNetworkInterface {
            print("[NetworkChecker] flagLostInternet true case 1")
            flagLostInternet = true
        } else if !SystemDataUsage.canGetSystemVpnInterface {
            print("[NetworkChecker] flagLostInternet true case 2")
            flagLostInternet = true
        } else {
            retryRefreshVPNConnect()
        }
    }
    
    func checkRetryLostInternetConnect() {
        if flagLostInternet {
            flagIsRertryConnect = true
        }
        
        print("[NetworkChecker] check connected Internet")
        
    }
    
    func resetByConnected() {
        flagIsRertryConnect = false
        flagLostInternet = false
        retryTime = 0
        lastRetryTime = Date().timeIntervalSince1970
    }
    
    func retryRefreshVPNConnect() {
        let now = Date().timeIntervalSince1970
        if lastRetryTime + 20  > now  {
            return
        }
        lastRetryTime = now
        flagIsRertryConnect = true
        print("[NetworkChecker] rety connect \(retryTime)")
        DependencyContainer.shared.vpnCore.retryConnection(retryTime)
        retryTime += 1
    }
    
    @objc func doPing(timer: Timer) {
        guard let pinger = timer.userInfo as? SwiftyPing else {
            return
        }
        try? pinger.startPinging()
    }
    
    func cancelPing() {
        timerPingInternet?.invalidate()
        internetPinger?.stopPinging()
    }
    
    func onTimeout() {
        
    }
}
