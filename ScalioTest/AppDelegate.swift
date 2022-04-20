//
//  AppDelegate.swift
//  ScalioTest
//
//  Created by Helia Fathi on 4/13/22.
//

import UIKit
import Moya


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    static func shared()-> AppDelegate {
        UIApplication.shared.delegate as! AppDelegate
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let homeViewController = HomeViewController()

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        homeViewController.viewModel = VCViewModelImpl(dataStore: GitDatas(provider: MoyaProvider<GitHub>()))

        
        let mainNavigationVC = UINavigationController()
        mainNavigationVC.viewControllers = [homeViewController]
        window?.rootViewController = mainNavigationVC
        

        return true
    }
}

