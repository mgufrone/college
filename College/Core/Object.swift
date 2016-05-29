//
//  Object.swift
//  College
//
//  Created by Moch Gufron on 5/29/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift

extension Object{
    static func all<T: Object>() -> Results<T>{
        let realm = try! Realm()
        return realm.objects(T)
    }
    static func count() -> Int{
        return self.all().count
    }
}