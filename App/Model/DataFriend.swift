//
//  DataFriend.swift
//  App
//
//  Created by mac on 2024/9/26.
//

import Foundation

class DataFriend{
    var name:String
    var status:Int
    var isTop:Bool
    var fid:String
    var updateDate:Date
    
    init(name:String, status:Int, isTop:Bool, fid:String, updateDate:Date) {
        self.name = name
        self.status = status
        self.isTop = isTop
        self.fid = fid
        self.updateDate = updateDate
    }
}
