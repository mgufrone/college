//
//  AnimatorHelper.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import UIKit

class AnimatorHelper {
    class func animateCell(cell: UITableViewCell) {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values =  [0, 20, -20, 10, 0]
        animation.keyTimes = [0, (1 / 6.0), (3 / 6.0), (5 / 6.0), 1]
        animation.duration = 0.3
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        animation.additive = true
        cell.layer.addAnimation(animation, forKey: "shake")
    }
}