//
//  FormScheduleController.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
import Eureka
import Validator
import AMSmoothAlert
class FormScheduleController: FormViewController{
    var schedule: Schedule?
    struct Tags{
        static let Subject: String = "subject"
        static let Description: String = "description"
        static let Lecturer: String = "lecturer"
        static let Date: String = "date"
        static let Start: String = "start"
        static let End: String = "end"
        static let Room: String = "room"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let titleForm = schedule != nil ? "UPDATE_SCHEDULE" : "NEW_SCHEDULE"
        self.title = titleForm.localize
        self.navigationItem.title = self.title
        form +++ Section("NOTES".localize){_ in 
            
            } <<< TextRow(Tags.Subject){ row in
                row.placeholder = "SUBJECT_PLACEHOLDER".localize
                row.title = "SUBJECT_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?.subject
                }
                }
            <<< TextRow(Tags.Room) { row in
                row.placeholder = "ROOM_PLACEHOLDER".localize
                row.title = "ROOM_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?.room
                }
            }
            <<< TextRow(Tags.Lecturer) { row in
                row.placeholder = "LECTURER_PLACEHOLDER".localize
                row.title = "LECTURER_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?.subject
                }
            }
            <<< TextAreaRow(Tags.Description) { row in
            row.placeholder = "DESCRIPTION_PLACEHOLDER".localize
                row.placeholder = "LECTURER_PLACEHOLDER".localize
                row.title = "LECTURER_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?._description
                }
        }
        form +++= Section("DATES".localize){ _ in
            
            } <<< DateRow(Tags.Date){ row in
                row.title = "DATE_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?.startDate
                }
            } <<< TimeRow(Tags.Start){ row in
                row.title = "TIME_START_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?.startDate
                }
                
            } <<< TimeRow(Tags.End){ row in
                row.title = "TIME_END_TITLE".localize
                if checkSchedule(){
                    row.value = schedule?.endDate
                }
        }
    }
    func checkSchedule() -> Bool{
        guard let _ = schedule else{
            return false
        }
        return true
    }
    @IBAction func saveSchedule(sender: UIBarButtonItem) {
        let values = form.values()
        let result = valid()
        switch result.0 {
        case true:
            Realm.write { realm in
                var update: Bool = false
                if let _ = self.schedule{
                    update = true
                }
                else{
                    self.schedule = Schedule()
                    self.schedule!.id = Schedule.count() + 1
                }
                self.schedule!.subject = values[Tags.Subject] as! String
                self.schedule!._description = values[Tags.Description] as! String
                self.schedule!.lecturer = values[Tags.Lecturer] as! String
                self.schedule!.room = values[Tags.Room] as! String
                let dateFormatter = NSDateFormatter()
                let timeFormatter = NSDateFormatter()
                let dateTimeFormatter = NSDateFormatter()
                dateTimeFormatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
                dateFormatter.dateFormat = "YYYY-MM-dd"
                timeFormatter.dateFormat = "HH:mm:00"
                let date = values[Tags.Date] as! NSDate
                let start = values[Tags.Start] as! NSDate
                let end = values[Tags.End] as! NSDate
                let startDate = dateTimeFormatter.dateFromString("\(dateFormatter.stringFromDate(date)) \(timeFormatter.stringFromDate(start))")
                let endDate = dateTimeFormatter.dateFromString("\(dateFormatter.stringFromDate(date)) \(timeFormatter.stringFromDate(end))")
                self.schedule!.startDate = startDate!
                self.schedule!.endDate = endDate!
                realm.add(self.schedule!, update: update)
            }
            
            let alert = AMSmoothAlertView(dropAlertWithTitle: "SCHEDULE_SAVED".localize, andText: "SCHEDULE_SAVED_MESSAGE".localize, andCancelButton: false, forAlertType: AlertType.Success)
            alert.completionBlock = { alertObj, button in
                self.performSegueWithIdentifier("unwindToSchedule", sender: nil)
            }
            alert.show()
        case false:
            for (_, error) in result.1.enumerate(){
                let row = form.rowByTag(error.0)
                switch error.1 {
                case .Valid:
                    row?.baseCell.textLabel?.textColor = UIColor.blackColor()
                    self.tableView?.reloadRowsAtIndexPaths([(row?.indexPath())!], withRowAnimation: UITableViewRowAnimation.None)
                case .Invalid(_):
                    row?.baseCell.textLabel?.textColor = UIColor.redColor()
                    AnimatorHelper.animateCell((row?.baseCell)!)
                }
            }
        }
    }
    
    func valid() -> (Bool, ScheduleValidatorResult){
        return ScheduleValidator(data: form.values()).validate()
    }
}
