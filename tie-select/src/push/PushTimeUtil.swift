//
//  PushTimeUtil.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/01.
//

import UIKit

final class PushTimeUtil {
    static var shared = PushTimeUtil()
    // 時間帯フォーマット指定
    private let formatter: DateFormatter = DateFormatter()
    init() {
        self.formatter.locale = Locale(identifier: "ja_JP")
        self.formatter.timeZone = TimeZone(identifier: "Asia/Tokyo")
        self.formatter.dateStyle = .none
        self.formatter.timeStyle = .short
    }

    func set(date: Date) {
        UserDefaults.standard.set(self.formatter.string(from: date), forKey: "pushTime")
    }

    func getString() -> String {
        let res = UserDefaults.standard.string(forKey: "pushTime") ?? "07:00"
        return res.count == 5 ? res : "0" + res
    }

    func getDate() -> Date {
        let time = UserDefaults.standard.string(forKey: "pushTime") ?? "07:00"
        return self.formatter.date(from: time)!
    }

    func getNextTime() -> Date {
        // 設定時間 > 現在時刻 なら当日、そうでないなら翌日
        var target = self.getDate() > self.formatter.date(from: self.formatter.string(from: Date()))!
                        ? Date() : Date().getTomorrow()
        // 土日祝なら翌日
        while (target.isSaturDay() || target.isSunday() || target.isJpHoliday()) {
            target = target.getTomorrow()
        }
        return target
    }
}
