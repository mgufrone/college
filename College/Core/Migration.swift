//
//  Migration.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class Migration {
    static func migrate(){
        Realm.Configuration.defaultConfiguration = Realm.Configuration(
            schemaVersion: 2,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    // The enumerate(_:_:) method iterates
                    // over every Person object stored in the Realm file
                    migration.enumerate(Schedule.className()) { oldObject, newObject in
                        
                    }
                    migration.enumerate(Task.className()) { oldObject, newObject in
                        
                    }
                }
                if oldSchemaVersion < 2{
                    migration.enumerate(Schedule.className()) { oldObject, newObject in
                        
                    }
                    migration.enumerate(Task.className()) { oldObject, newObject in
                        
                    }
                }
        })
    }
}