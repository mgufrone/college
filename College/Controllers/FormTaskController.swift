//
//  FormTaskController.swift
//  College
//
//  Created by Moch Gufron on 5/29/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
import Eureka
import AMSmoothAlert
class FormTaskController: FormViewController{
    var task: Task?
    struct Tags{
        static let Subject: String = "subject"
        static let Description: String = "description"
        static let Deadline: String = "deadline"
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let titleForm = task != nil ? "UPDATE_TASK" : "NEW_TASK"
        self.title = titleForm.localize
        self.navigationItem.title = self.title
        form +++ Section("NOTES".localize){_ in
            
            } <<< TextRow(Tags.Subject){ row in
                row.placeholder = "SUBJECT_PLACEHOLDER".localize
                row.title = "SUBJECT_TITLE".localize
                if checkTask(){
                    row.value = task?.subject
                }
            }
            <<< TextAreaRow(Tags.Description) { row in
                row.placeholder = "DESCRIPTION_PLACEHOLDER".localize
                row.placeholder = "DESCRIPTION_PLACEHOLDER".localize
                row.title = "DESCRIPTION_TITLE".localize
                if checkTask(){
                    row.value = task?._description
                }
                
                }
            <<< DateTimeRow(Tags.Deadline){ row in
                    row.title = "DATE_TITLE".localize
                    if checkTask(){
                        row.value = task?.endDate
                    }
        }
    }
    
    
    func checkTask() -> Bool{
        guard let _ = task else{
            return false
        }
        return true
    }
    @IBAction func saveTask(sender: UIBarButtonItem) {
        let values = form.values()
        let result = valid()
        switch result.0 {
        case true:
            Realm.write { realm in
                var update: Bool = false
                if let _ = self.task{
                    update = true
                }
                else{
                    self.task = Task()
                    self.task!.id = Task.count() + 1
                }
                self.task!.subject = values[Tags.Subject] as! String
                self.task!._description = values[Tags.Description] as! String
                let deadline = values[Tags.Deadline] as! NSDate
                self.task!.endDate = deadline
                realm.add(self.task!, update: update)
            }
            
            let alert = AMSmoothAlertView(dropAlertWithTitle: "TASK_SAVED".localize, andText: "TASK_SAVED_MESSAGE".localize, andCancelButton: false, forAlertType: AlertType.Success)
            alert.completionBlock = { alertObj, button in
                self.performSegueWithIdentifier("unwindToTask", sender: nil)
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
    
    func valid() -> (Bool, TaskValidatorResult){
        return TaskValidator(data: form.values()).validate()
    }

}