//
//  pawfectMatchApp.swift
//  pawfectMatch
//
//  Created by Keya Gholap on 10/16/23.
//

import SwiftUI

@main
struct pawfectMatchApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        UNUserNotificationCenter.current().delegate = self
        // Other setup code...
        return true
    }

    // UNUserNotificationCenterDelegate method
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
    ) {
        // Show the notification both when the app is in the foreground and background
        print("Received notification while app is in foreground")
        completionHandler([.banner, .sound, .badge])
    }
}


