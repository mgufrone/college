//
//  ScheduleController.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm
import UIKit
import AMSmoothAlert

class ScheduleController: UITableViewController {
    var data: SectionedSchedule?
    var currentIndex: NSIndexPath?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadData()
    }
    func loadData(){
        Schedule.sections(true) { data in
            self.data = data
            if self.data?.count == 0{
                let messageLabel = UILabel(frame: CGRectMake(0,0,self.view.bounds.size.width,self.view.bounds.size.height))
                messageLabel.text = "NO_SCHEDULE".localize
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
        let cell = tableView.dequeueReusableCellWithIdentifier(ScheduleCell.className) as! ScheduleCell
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
            self.performSegueWithIdentifier(FormScheduleController.className, sender: self.data![indexPath.section].1[indexPath.row])
            })
        results.append(UITableViewRowAction(style: UITableViewRowActionStyle.Default, title: "ACTION_DELETE".localize){ row, _ in
            self.currentIndex = indexPath
            let alert = AMSmoothAlertView(fadeAlertWithTitle: "DELETE_RECORD_TITLE".localize, andText: "DELETE_RECORD_MESSAGE".localize, andCancelButton: true, forAlertType: AlertType.Failure)
            alert.completionBlock = { alertObj, button in
                if button == alertObj.defaultButton{
                    let record: Schedule = self.data![indexPath.section].1[indexPath.row]
                    Realm.write { realm in
                        realm.delete(record)
                        self.tableView.deleteRowsAtIndexPaths([self.currentIndex!], withRowAnimation: UITableViewRowAnimation.Automatic)
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
        let destination = segue.destinationViewController
        if segue.identifier == FormScheduleController.className{
            let mc = destination as! FormScheduleController
            mc.schedule = sender as? Schedule
        }
    }
    
    @IBAction func createNew(sender: UIBarButtonItem) {
        self.performSegueWithIdentifier(FormScheduleController.className, sender: nil)
    }
    
    @IBAction func unwindToSchedule(segue: UIStoryboardSegue){
        self.loadData()
        self.tableView.reloadData()
    }
}
