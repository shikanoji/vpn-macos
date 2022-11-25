//
//  AppAlertManager.swift
//  sysvpn-macos
//
//  Created by macbook on 26/11/2022.
//

import Foundation
import UserNotifications
import AppKit


class AppAlertManager: NSObject {
    static let shared = AppAlertManager()
    
    
    func showAlert(title: String, message: String) {
        if !PropertiesManager.shared.systemNotification {
            return
        }
        let notificationCenter = UNUserNotificationCenter.current();
        notificationCenter.getNotificationSettings
        { (settings) in
            if settings.authorizationStatus == .authorized
            {
                let content = UNMutableNotificationContent();
                content.title = title ;
                content.body = message ;
                content.sound = UNNotificationSound.default
                 
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false);
                
                // Create the request
                let uuidString = UUID().uuidString ;
                let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger);
                 
                notificationCenter.add(request, withCompletionHandler:
                                        { (error) in
                    if error != nil
                    {
                        // Something went wrong
                    }
                })
                //print ("Notification Generated");
            } else {
                PropertiesManager.shared.systemNotification = false
            }
        }
        
    }
    
    
    func requestPermission() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
            if success {
                print("All set!")
            } else if let error = error {
                print(error.localizedDescription)
            }
            DispatchQueue.main.async {
                NSApplication.shared.registerForRemoteNotifications()
            }
        }
    }
}

extension AppAlertManager: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
 
           completionHandler([.alert, .badge, .sound])
       }
}
