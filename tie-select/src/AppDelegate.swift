//
//  AppDelegate.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        NotificationUtil.shared.showPushPermit { result in
            switch result {
            case .success(_):
                UNUserNotificationCenter.current().delegate = self
            case .failure(let error):
                debugPrint(error.localizedDescription)
            }
        }
        return true
    }

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

}

