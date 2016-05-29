//
//  TaskController.swift
//  College
//
//  Created by Moch Gufron on 5/29/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
import AMSmoothAlert

class TaskController: UITableViewController{
    var data: SectionedTask?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    
    func loadData(){
        Task.sections(true) { data in
            self.data = data
            if self.data?.count == 0{
                let messageLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
                messageLabel.text = "NO_TASKS".localize
                messageLabel.textColor = UIColor.blackColor()
                messageLabel.numberOfLines = 0
                messageLabel.textAlignment = .Center
                self.tableView.backgroundView = messageLabel
                self.tableView.separatorStyle = .None
            }
        }
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return (data?.count)!
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data![section].1.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(TaskCell.className) as! TaskCell
        let row = self.data![indexPath.section].1[indexPath.row]
        cell.setup(row)
        return cell
    }
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = self.data![section].0
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MMM dd, YYYY"
        return dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: key))
    }
    override func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        var results: [UITableViewRowAction] = []
        results.append(UITableViewRowAction(style: UITableViewRowActionStyle.Normal, title: "ACTION_EDIT".localize){ row, _ in
            self.performSegueWithIdentifier(FormTaskController.className, sender: self.data![indexPath.section].1[indexPath.row])
            })
        results.append(UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "ACTION_DELETE".localize){ row, _ in
            let alert = AMSmoothAlertView(fadeAlertWithTitle: "DELETE_RECORD_TITLE".localize, andText: "DELETE_RECORD_MESSAGE".localize, andCancelButton: true, forAlertType: AlertType.Failure)
            alert.completionBlock = { alertObj, button in
                if button == alertObj.defaultButton{
                    let record: Task = self.data![indexPath.section].1[indexPath.row]
                    Realm.write { realm in
                        realm.delete(record)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    }
                    self.loadData()
                }
            }
            alert.show()
            })
        return results
    }
    override func tableView(tableView: UITableView, canPerformAction action: Selector, forRowAtIndexPath indexPath: NSIndexPath, withSender sender: AnyObject?) -> Bool {
        return true
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let mc = segue.destinationViewController
        if segue.identifier == FormTaskController.className{
            let controller = mc as! FormTaskController
            controller.task = sender as? Task
        }
    }
    
    @IBAction func createNew(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(FormTaskController.className, sender: nil)
    }
    
    @IBAction func unwindToTask(segue: UIStoryboardSegue){
        self.loadData()
        self.tableView.reloadData()
    }
    
}