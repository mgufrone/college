//
//  Task.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
typealias SectionedTask = [(Double, Results<Task>)]
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
    static func sections(activeOnly: Bool = false, callback: (tasks: SectionedTask) -> Void){
        Realm.read { realm in
            var results: SectionedTask = SectionedTask()
            var dates: [NSDate] = []
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd"
            
            var objects: Results<Task> = self.all().sorted("endDate", ascending: true)
            if activeOnly{
                let filter = NSPredicate(format: "endDate >= %@", NSDate())
                objects = objects.filter(filter)
            }
            for object in objects{
                let date = dateFormat.dateFromString(dateFormat.stringFromDate(object.endDate))
                if !dates.contains(date!){
                    dates.append(date!)
                }
            }
            for date in dates{
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let endFormatter = NSDateFormatter()
                endFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                let startDate = dateFormatter.dateFromString("\(dateFormat.stringFromDate(date)) 00:00:00")!
                let endDate = dateFormatter.dateFromString("\(dateFormat.stringFromDate(date)) 23:59:59")!
                let filter = NSPredicate(format: "endDate >= %@ and endDate <= %@", startDate, endDate)
                let query = objects.filter(filter)
                results.append( (date.timeIntervalSince1970, query) )
            }
            callback(tasks: results)
        }
    }
    
    static func all() -> Results<Task>{
        let realm = try! Realm()
        return realm.objects(self)
    }
    static func count() -> Int{
        return self.all().count
    }
    
}
