//
//  AppDelegate.swift
//  ScannAR
//
//  Created by ScannAR Team on 3/20/19.
//

import UIKit
import ARKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        // FIXME: - Remove for production
        guard ARObjectScanningConfiguration.isSupported, ARWorldTrackingConfiguration.isSupported else {
            fatalError("""
                ARKit is not available on this device. For apps that require ARKit
                for core functionality, use the `arkit` key in the key in the
                `UIRequiredDeviceCapabilities` section of the Info.plist to prevent
                the app from installing. (If the app can't be installed, this error
                can't be triggered in a production scenario.)
                In apps where AR is an additive feature, use `isSupported` to
                determine whether to show UI for launching AR experiences.
            """) // For details, see https://developer.apple.com/documentation/arkit
        }
        
        return true
    }

    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            viewController.readFile(url)
            return true
        } else {
            return false
        }
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            viewController.backFromBackground()
        }
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            viewController.blurView?.isHidden = false
        }
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        if let viewController = self.window?.rootViewController as? ARScanViewController {
            viewController.blurView?.isHidden = true
        }
    }

}

