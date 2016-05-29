//
//  Schedule.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
typealias SectionedSchedule = [(Double, Results<Schedule>)]
typealias SectionedScheduleCallback = (results: SectionedSchedule) -> Void
class Schedule: Object {
    dynamic var subject: String = ""
    dynamic var _description: String = ""
    dynamic var lecturer: String = ""
    dynamic var room: String = ""
    dynamic var startDate: NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var endDate: NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var lastReminder: NSDate = NSDate(timeIntervalSince1970: 1)
    dynamic var id = 0
    
    override static func primaryKey() -> String?{
        return "id"
    }
    static func sections(activeOnly: Bool = true, callback: SectionedScheduleCallback){
        Realm.read { realm in
            var results: SectionedSchedule = SectionedSchedule()
            var dates: [NSDate] = []
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "YYYY-MM-dd"
            
            var objects: Results<Schedule> = self.all().sorted("startDate", ascending: true)
            if activeOnly{
                let filter = NSPredicate(format: "startDate >= %@", NSDate())
                objects = objects.filter(filter)
            }
            for object in objects{
                let date = dateFormat.dateFromString(dateFormat.stringFromDate(object.startDate))
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
                let filter = NSPredicate(format: "startDate >= %@ and endDate <= %@", startDate, endDate)
                let query = objects.filter(filter)
                results.append( (date.timeIntervalSince1970, query) )
            }
            callback(results: results)
        }
    }
// Specify properties to ignore (Realm won't persist these)
    
//  override static func ignoredProperties() -> [String] {
//    return []
//  }
}
