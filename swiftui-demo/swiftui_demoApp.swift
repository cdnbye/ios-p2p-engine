//
//  swiftui_demoApp.swift
//  swiftui-demo
//
//  Created by timmy on 2024/11/27.
//

import SwiftUI

@main
struct swiftui_demoApp: App {
    
#if canImport(UIKit)
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#elseif canImport(AppKit)
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
#endif
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
