//
//  HistoryService.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/01.
//

import RealmSwift

final class HistoryService {
    static var shared = HistoryService()
    // 日付フォーマット指定
    private let formatter: DateFormatter = DateFormatter()
    init() {
        self.formatter.calendar = Calendar(identifier: .gregorian)
        self.formatter.dateFormat = "yyyy/MM/dd"
    }

    // 日付から取得
    func selectByDate(date: Date) -> HistoryModel? {
        if let target = try! Realm().objects(HistoryModel.self)
                .filter("%K == %d", "historyDate", self.formatter.string(from: date)).first {
            return target
        } else {
            return nil
        }
    }

    // 登録
    func register(tie: TieModel, date: Date) -> HistoryModel {
        let realm = try! Realm()
        // すでに登録があれば更新
        if let target = realm.objects(HistoryModel.self)
            .filter("%K == %d", "historyDate", self.formatter.string(from: date)).first {
            try! realm.write {
                target.tieName = tie.name
                target.tieMainColor = tie.mainColor
            }
            return target
        // なければ登録
        } else {
            let history = HistoryModel()
            history.historyDate = self.formatter.string(from: date)
            try! realm.write { realm.add(history) }
            return history
        }
    }
}
