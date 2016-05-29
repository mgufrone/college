//
//  Realm.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
typealias RealmCallback = (realm: Realm) -> Void
extension Realm{
    static func read(callback: RealmCallback){
        let realm = try! Realm()
        callback(realm: realm)
    }
    static func write(callback: RealmCallback){
        let realm = try! Realm()
        try! realm.write {
            callback(realm: realm)
        }
    }
}