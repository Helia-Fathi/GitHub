//
//  AppDelegate.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/13/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    static func shared()-> AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        
        let mainNavigationVC = UINavigationController()
        window?.rootViewController = mainNavigationVC
        
        return true
    }
}

