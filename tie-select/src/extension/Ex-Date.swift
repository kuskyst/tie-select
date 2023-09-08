//
//  Ex-Date.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/02.
//

import UIKit
import CalculateCalendarLogic

extension Date {
    func isSunday() -> Bool {
        return Calendar(identifier: .gregorian).component(.weekday, from: self) == 1
    }
    func isSaturDay() -> Bool {
        return Calendar(identifier: .gregorian).component(.weekday, from: self) == 7
    }
    func isJpHoliday() -> Bool {
        let cal = Calendar(identifier: .gregorian)
        return UserDefaults.standard.integer(forKey: "pushInterval") == 0 &&
            CalculateCalendarLogic().judgeJapaneseHoliday(
                year: cal.component(.year, from: self),
                month: cal.component(.month, from: self),
                day: cal.component(.day, from: self))
    }
    func getTomorrow() -> Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: self)!
    }
}
