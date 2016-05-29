//
//  String.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
extension String{
    var localize: String{
        return NSLocalizedString(self, comment: "")
    }
}