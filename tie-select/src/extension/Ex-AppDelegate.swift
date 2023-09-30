//
//  AppDelegate.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/13.
//

import UserNotifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            if #available(iOS 14.0, *) {
                completionHandler([[.banner, .list, .sound]])
            } else {
                completionHandler([[.alert, .sound]])
            }
        }
}
