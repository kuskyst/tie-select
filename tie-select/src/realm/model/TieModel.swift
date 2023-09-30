//
//  TieModel.swift
//  tie-select
//
//  Created by kohsaka on 2022/10/12.
//

import RealmSwift

class TieModel: Object {
    // ID
    @objc dynamic var id: Int = 0
    // 名称
    @objc dynamic var name: String = ""
    // メインカラー
    @objc dynamic var mainColor: String = "#000000"

}
