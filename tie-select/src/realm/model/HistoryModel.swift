//
//  HistoryModel.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/15.
//

import RealmSwift

class HistoryModel: Object {
    // 日付
    @objc dynamic var historyDate: String = "2000/01/01"
    // 名称
    @objc dynamic var tieName: String = ""
    // ネクタイメインカラー
    @objc dynamic var tieMainColor: String = "#000000"

}
