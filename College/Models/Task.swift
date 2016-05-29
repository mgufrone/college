//
//  Task.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
    dynamic var subject: String = ""
    dynamic var _description: String = ""
    dynamic var room: String = ""
    dynamic var startDate: NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var endDate: NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var lastReminder: NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var id = 0
    
    override static func primaryKey() -> String?{
        return "id"
    }
}
