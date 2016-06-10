//
//  Globle.swift
//  Model Code Builder
//
//  Created by Tun Lan on 6/3/16.
//  Copyright © 2016 Tun Lan. All rights reserved.
//

import Foundation

class Global {
    var source:[[String:AnyObject]] = [[String:AnyObject]]()
    static func fakeSourceApi()-> [[String:AnyObject]]{
        var fakeSource:[[String:AnyObject]] = [[String:AnyObject]]()
        for i in 0...5{
            var fakeparameter:[[String:AnyObject]] = [[String:AnyObject]]()
            for j in 0...8 {
                let item:[String:AnyObject] = ["name": "parameter\(j)", "type": "String", "alias": "\(j)", "remark": "parameterMark\(j)"]
                fakeparameter.append(item)
            }
            let fakeModel:[String:AnyObject] = ["name": "model\(i)", "item": fakeparameter, "remark": "remark\(i)"]
            fakeSource.append(fakeModel)
        }
        return fakeSource
    }
}