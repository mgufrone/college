//
//  TaskCell.swift
//  College
//
//  Created by Moch Gufron on 5/29/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import UIKit

class TaskCell: UITableViewCell{
    
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var _description: UILabel!
    @IBOutlet weak var deadline: UILabel!
    func setup(task: Task){
        subject.text = task.subject
        _description.text = task._description
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        deadline.text = formatter.stringFromDate(task.endDate)
    }
}