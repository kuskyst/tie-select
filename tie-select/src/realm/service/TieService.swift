//
//  TieService.swift
//  tie-select
//
//  Created by kohsaka on 2023/04/01.
//

import RealmSwift

final class TieService {
    static var shared = TieService()
    // 全取得
    func selectAll() -> Results<TieModel> {
        return try! Realm().objects(TieModel.self)
    }
    
    // ランダム1取得
    func selectRandom() -> TieModel? {
        if let random = try! Realm().objects(TieModel.self).randomElement() {
            return random
        } else {
            return nil
        }
    }
    
    // IDで1取得
    func selectById(id: Int) -> TieModel? {
        return try! Realm().objects(TieModel.self).filter("id == \(id)").first
    }

    // 登録
    func register(tie: TieModel) -> TieModel? {
        let realm = try! Realm()
        if let largestId = realm.objects(TieModel.self).sorted(byKeyPath: "id", ascending: false).first {
            tie.id = largestId.id + 1
        } else {
            tie.id = 1
        }
        try! realm.write { realm.add(tie) }
        return tie
    }

    // IDで1更新
    func updateById(tie: TieModel) -> TieModel? {
        let realm = try! Realm()
        if let target = realm.objects(TieModel.self).filter("id == \(tie.id)").first {
            try! realm.write {
                target.name = tie.name
                target.mainColor = tie.mainColor
            }
            return target
        } else {
            return nil
        }
    }

    // IDで1削除
    func deleteById(id: Int) {
        let realm = try! Realm()
        let target = realm.objects(TieModel.self).filter("id == \(id)")
        try! realm.write { realm.delete(target) }
    }
}
