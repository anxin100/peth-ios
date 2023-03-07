//
//  AppDelegate.swift
//  Peth
//
//  Created by qiangl on 28.02.2023.
//

import Foundation
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {

  private var rootViewController: RootViewController?
  internal var window: UIWindow?

  func application(_ application: UIApplication, willFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    return true
  }
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    let rootViewController =  RootViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.backgroundColor = .black
    window?.rootViewController = rootViewController
    window?.makeKeyAndVisible()
    return true
  }
}
