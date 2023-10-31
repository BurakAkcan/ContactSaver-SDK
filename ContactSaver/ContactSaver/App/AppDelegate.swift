//
//  AppDelegate.swift
//  ContactSaver
//
//  Created by Burak AKCAN on 29.10.2023.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let saveContactVC = SaveContactsVC(nibName: "SaveContactsVC", bundle: nil)
        let navigationController = UINavigationController(rootViewController: saveContactVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
        return true
    }
 }

