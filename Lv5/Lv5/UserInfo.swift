//
//  UserInfo.swift
//  Lv5
//
//  Created by 이재희 on 2023/07/21.
//

import Foundation

class UserInfo {
    
    let userName: String
    
    var balance = 0
    var isPremium = false
    var reservationList: [Reservation] = []
    var inoutData: InoutData = []
    
    init(userName: String) {
        self.userName = userName
    }
}
