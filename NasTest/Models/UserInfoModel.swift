//
//  UserInfoModel.swift
//  NasTest
//
//  Created by suyong.lim on 2017. 11. 21..
//  Copyright © 2017년 suyong.lim. All rights reserved.
//

import Foundation
import ObjectMapper

struct UserInfoModel: Mappable {
    var user_id = ""
    var password = ""
    var last_login = ""
    var last_login_date = Date()
    var id = ""
    
    init() {}
    
    init?(map: Map) {
        self.init()
    }
    
    mutating func mapping(map: Map) {
        user_id <- map["userInfo.user_id"]
        last_login <- map["userInfo.last_login"]
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        last_login_date = formatter.date(from: last_login) ?? Date()
        id <- map["userInfo.id"]
        password = ""
    }
}
