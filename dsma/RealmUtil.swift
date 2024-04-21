//
//  RealmUtil.swift
//  dsma
//
//  Created by apple on 2024/04/22.
//  Copyright © 2024 LinaNfinE. All rights reserved.
//

import Foundation
import RealmSwift

class RealmUtil {
    let realm = try! Realm() // Realmインスタンスの取得
    
    func saveOrUpdateMemo(id: Int, text: String) {

        try! realm.write {
            let newItem = SongMemo()
            newItem.id = id
            newItem.text = text
            // update: .modified を指定して既存データを上書き更新または新規追加
            realm.add(newItem, update: .modified)
        }
    }
    
    func loadMemo(id: Int) -> String {
        if let item = realm.object(ofType: SongMemo.self, forPrimaryKey: id) {
            // 指定されたIDに対応するアイテムが存在する場合、そのテキストを返す
            return item.text
        } else {
            // アイテムが存在しない場合、空の文字列を返す
            return ""
        }
    }
}

class SongMemo: Object {
    @objc dynamic var id = 0
    @objc dynamic var text = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
