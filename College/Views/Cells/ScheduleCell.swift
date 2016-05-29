//
//  ScheduleCell.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import UIKit

class ScheduleCell: UITableViewCell {
    @IBOutlet weak var room: UILabel!
    @IBOutlet weak var timeStart: UILabel!
    @IBOutlet weak var subject: UILabel!
    @IBOutlet weak var lecturer: UILabel!
    @IBOutlet weak var _description: UILabel!
    func setup(data: Schedule){
        room.text = data.room
        subject.text = data.subject
        lecturer.text = data.lecturer
        _description.text = data._description
        let formatter = NSDateFormatter()
        formatter.dateFormat = "HH:mm"
        timeStart.text = formatter.stringFromDate(data.startDate)
    }
}