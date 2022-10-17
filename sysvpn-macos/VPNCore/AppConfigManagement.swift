//
//  AppConfigManagement.swift
//  TunnelKitDemo-macOS
//
//  Created by macbook on 09/10/2022.
//  Copyright © 2022 Davide De Rosa. All rights reserved.
//

import Foundation


protocol PropertiesManagerProtocol: AnyObject {
    
    static var hasConnectedNotification: Notification.Name { get }
    static var userIpNotification: Notification.Name { get }
    static var earlyAccessNotification: Notification.Name { get }
    static var vpnProtocolNotification: Notification.Name { get }
    static var excludeLocalNetworksNotification: Notification.Name { get }
    static var killSwitchNotification: Notification.Name { get }
    
    var onAlternativeRoutingChange: ((Bool) -> Void)? { get set }
    
    func getAutoConnect(for username: String) -> (enabled: Bool, profileId: String?)
    func setAutoConnect(for username: String, enabled: Bool, profileId: String?)
    
    var hasConnected: Bool { get set }
    var lastOpenVpnConnection: ConnectionConfiguration? { get set }
    var lastWireguardConnection: ConnectionConfiguration? { get set }
    
    var excludeLocalNetworks: Bool{ get }
    var killSwitch: Bool { get }
    
}

class PropertiesManager : PropertiesManagerProtocol {
     
    static let shared = PropertiesManager()
    internal enum Keys: String, CaseIterable {
        
        case autoConnect = "AutoConnect"
        case autoConnectProfile = "AutoConnect_"
        case connectOnDemand = "ConnectOnDemand"
        case lastIkeConnection = "LastIkeConnection"
        case lastOpenVpnConnection = "LastOpenVPNConnection"
        case lastWireguardConnection = "LastWireguardConnection"
        case lastPreparingServer = "LastPreparingServer"
        case lastConnectedTimeStamp = "LastConnectedTimeStamp"
        case lastConnectionRequest = "LastConnectionRequest"
        case lastUserAccountPlan = "LastUserAccountPlan"
        case quickConnectProfile = "QuickConnect_"
        case secureCoreToggle = "SecureCoreToggle"
        case intentionallyDisconnected = "IntentionallyDisconnected"
        case userLocation = "UserLocation"
        case userDataDisclaimerAgreed = "UserDataDisclaimerAgreed"
        case lastBugReportEmail = "LastBugReportEmail"

        // Subscriptions
        case servicePlans = "servicePlans"
        case currentSubscription = "currentSubscription"
        case defaultPlanDetails = "defaultPlanDetails"
        case isIAPUpgradePlanAvailable = "isIAPUpgradePlanAvailable" // Old name is left for backwards compatibility
        
        // Trial
        case trialWelcomed = "TrialWelcomed"
        case warnedTrialExpiring = "WarnedTrialExpiring"
        case warnedTrialExpired = "WarnedTrialExpired"
        
        // OpenVPN
        case openVpnConfig = "OpenVpnConfig"
        case vpnProtocol = "VpnProtocol"
        
        case apiEndpoint = "ApiEndpoint"
        
        // Migration
        case lastAppVersion = "LastAppVersion"
        
        // AppState
        case lastTimeForeground = "LastTimeForeground"

        // Discourage Secure Core
        case discourageSecureCore = "DiscourageSecureCore"

        // Did Show New Brand Modal
        case newBrandModalShown = "NewBrandModalShown"

        // Kill Switch
        case killSwitch = "Firewall"
        case excludeLocalNetworks = "excludeLocalNetworks"
        
        // Features
        case featureFlags = "FeatureFlags"
        case maintenanceServerRefreshIntereval = "MaintenanceServerRefreshIntereval"
        case vpnAcceleratorEnabled = "VpnAcceleratorEnabled"
        
        case humanValidationFailed = "humanValidationFailed"
        case alternativeRouting = "alternativeRouting"
        case smartProtocol = "smartProtocol"
        case streamingServices = "streamingServices"
        case streamingResourcesUrl = "streamingResourcesUrl"

        case wireguardConfig = "WireguardConfig"
        case smartProtocolConfig = "SmartProtocolConfig"
        case ratingSettings = "RatingSettings"
 
    }
    
     static let hasConnectedNotification = Notification.Name("HasConnectedChanged")
     static let userIpNotification = Notification.Name("UserIp")
     static let featureFlagsNotification = Notification.Name("FeatureFlags")
     static let earlyAccessNotification: Notification.Name = Notification.Name("EarlyAccessChanged")
     static let vpnProtocolNotification: Notification.Name = Notification.Name("VPNProtocolChanged")
     static let killSwitchNotification: Notification.Name = Notification.Name("KillSwitchChanged")
     static let excludeLocalNetworksNotification: Notification.Name = Notification.Name("ExcludeLocalNetworksChanged")
     var onAlternativeRoutingChange: ((Bool) -> Void)?
    
    
    var storage: UserDefaults = UserDefaults.standard
    
    
    
    var lastOpenVpnConnection: ConnectionConfiguration?
    
    var lastWireguardConnection: ConnectionConfiguration?
    
    
    public func getAutoConnect(for username: String) -> (enabled: Bool, profileId: String?) {
        let autoConnectEnabled = storage.bool(forKey: Keys.autoConnect.rawValue)
        let profileId = storage.string(forKey: Keys.autoConnectProfile.rawValue + username)
        return (autoConnectEnabled, profileId)
    }

    public func setAutoConnect(for username: String, enabled: Bool, profileId: String?) {
        storage.setValue(enabled, forKey: Keys.autoConnect.rawValue)
        if let profileId = profileId {
            storage.setValue(profileId, forKey: Keys.autoConnectProfile.rawValue + username)
        }
    }
    
    public var hasConnected: Bool {
        get {
            return storage.bool(forKey: Keys.connectOnDemand.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.connectOnDemand.rawValue)
            postNotificationOnUIThread(type(of: self).hasConnectedNotification, object: newValue)
        }
    }
    
    var excludeLocalNetworks: Bool {
        get {
            return storage.bool(forKey: Keys.excludeLocalNetworks.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.excludeLocalNetworks.rawValue)
            postNotificationOnUIThread(type(of: self).excludeLocalNetworksNotification, object: newValue)
        }
    }
    
    var killSwitch: Bool {
        get {
            return storage.bool(forKey: Keys.killSwitch.rawValue)
        }
        set {
            storage.setValue(newValue, forKey: Keys.killSwitch.rawValue)
            postNotificationOnUIThread(type(of: self).killSwitchNotification, object: newValue)
        }
    }
    
    func postNotificationOnUIThread(_ name: NSNotification.Name, object: Any?, userInfo: [AnyHashable: Any]? = nil) {
        
        executeOnUIThread {
            NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
        }
    }
    
    public var lastTimeForeground: Date? {
        get {
            guard let timeSince1970 = storage.value(forKey: Keys.lastTimeForeground.rawValue) as? Double else { return nil }
            return Date(timeIntervalSince1970: timeSince1970)
        }
        set {
            storage.setValue(newValue?.timeIntervalSince1970, forKey: Keys.lastTimeForeground.rawValue)
        }
    }
    

}
