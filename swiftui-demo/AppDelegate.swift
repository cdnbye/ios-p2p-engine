//
//  AppDelegate.swift
//  swiftui-demo
//
//  Created by timmy on 2024/11/27.
//

import Foundation
import SwarmCloudKit

func initP2pEngine() {
    let config = P2pConfig(
        trackerZone: .China,
//        p2pEnabled: false,
            p2pEnabled: true,
        debug: true,
        logLevel: .DEBUG
//            logPersistent: true,
//            hlsMediaFiles: ["$a", "ts"],
//            fastStartup: true,
//            signalConfig: SignalConfig(mainAddr: "ws://signal.swarmcloud.net", backupAddr: "wss://signal.cdnbye.com")
//            insertTagWithTimeOffset: 0.0,
//            diskCacheLimit: 10 * 1024 * 1024
    )
    P2pEngine.setup(token: "ZMuO5qHZg", config: config)
}

#if canImport(UIKit)
import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        initP2pEngine()
        return true
    }


}

#elseif canImport(AppKit)
import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ notification: Notification) {
        initP2pEngine()
    }


}
#endif