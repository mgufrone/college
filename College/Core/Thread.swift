//
//  Thread.swift
//  College
//
//  Created by Moch Gufron on 5/28/16.
//  Copyright © 2016 Gufy. All rights reserved.
//

import Foundation
import RxSwift

class Thread {
    static var DISPOSE_BAG: DisposeBag{
       return DisposeBag()
    }
    static func mainQueue(callback: dispatch_block_t){
        dispatch_async(dispatch_get_main_queue(), callback)
    }
}