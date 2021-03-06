//
//  AppDelegate.swift
//  10.2 Video Fix
//
//  Created by Tim Roesner on 12/28/16.
//  Copyright © 2016 Tim Roesner. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import AmplitudeLite

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override mute
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        
        // Analytics
		Analytics.shared.configure(withAPIKey: Credentials.analyticsKey)
        Analytics.shared.trackEvent(.appStart, includeDeviceInfo: true)
        // Workaround for a crash on iOS 10.3.3
        if #available(iOS 11.0, *) {
            Analytics.shared.trackEvent(.accessibilitySettings, properties: Analytics.accessibilityProperties)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
	
	func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
		guard let rootVC = app.keyWindow?.rootViewController else { return false }
		
		if let playerVC = rootVC.presentedViewController as? AVPlayerViewController {
			playerVC.dismiss(animated: false, completion: nil)
		}
		
		rootVC.presentPlayer(with: url)
		return true
	}
}

