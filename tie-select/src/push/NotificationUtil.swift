//
//  NotificationUtil.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/01.
//

import UIKit
import UserNotifications

final class NotificationUtil: NSObject, UNUserNotificationCenterDelegate {
    static var shared = NotificationUtil()
    private var center = UNUserNotificationCenter.current()

    func initialize() {
        self.center.delegate = NotificationUtil.shared
    }

    // 権限許可アラート表示
    func showPushPermit(completion: @escaping (Result<Bool, Error>) -> Void) {
        self.center.requestAuthorization(options: [.alert, .badge, .sound]) { isGranted, error in
            if let error = error {
                debugPrint(error.localizedDescription)
                completion(.failure(error))
                return
            }
            completion(.success(isGranted))
        }
    }

    // 通知定期送信
    func setTimerRequest() {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        formatter.dateFormat = "yyyy-MM-dd"
        // 現在予定されている通知を削除
        self.center.removeAllPendingNotificationRequests()
        // 通知時間の条件指定
        let targetDay = PushTimeUtil.shared.getNextTime()
        let sendTime = DateComponents(
            calendar: Calendar.current, timeZone: TimeZone.current,
            hour: Int(String(PushTimeUtil.shared.getString().prefix(2))),
            minute: Int(String(PushTimeUtil.shared.getString().suffix(2))))
        let trigger = UNCalendarNotificationTrigger(dateMatching: sendTime, repeats: false)
        // ローカル通知作成
        if let tie = TieService.shared.selectRandom() {
            let his = HistoryService.shared.register(tie: tie, date: targetDay)
            let content = UNMutableNotificationContent()
            content.title = "本日はこちら"
            content.body = his.tieName
            var image = UIImage(named: "tie")!
                .tinted(with: UIColor(hex: his.tieMainColor)!)
                .resize(size: CGSize.init(width: 18, height: 30))!
                .overlay(image: UIImage(named: "suit")!, width: 22, height: 22)

            if let imgUrl =
                image!.createLocalUrl(
                    forImageNamed: "tieSuit-\(formatter.string(from: targetDay))") {
                content.attachments =
                    [try! UNNotificationAttachment(identifier: "tie", url: imgUrl, options: nil)]
            }
            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
            UNUserNotificationCenter.current().add(request)
            center.add(request)
        }
    }

    // 通知受信時に翌日の履歴登録
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping
                                (UNNotificationPresentationOptions) -> Void) {
        self.setTimerRequest()
        completionHandler([.banner, .list, .sound])
    }

}
