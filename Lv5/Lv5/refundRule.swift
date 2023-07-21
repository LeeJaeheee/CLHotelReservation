//
//  refundRule.swift
//  Lv5
//
//  Created by 이재희 on 2023/07/21.
//

import Foundation

/*
 환불 금액
 체크인 당일 ~ 이후 : 환불 불가
 체크인 하루 전 : 50%
 체크인 4일 전 ~ 2일 전 : 70%
 체크인 7일 전 ~ 5일 전 : 90%
 그 이전 : 100%
 */

func calcRefund(info: Reservation) -> (Int, Int) {
    let checkinDate = dateFormatter.date(from: info.checkin)
    let todayStr = dateFormatter.string(from: Date())
    let today = dateFormatter.date(from: todayStr)
    let diffDays = Int(checkinDate!.timeIntervalSinceReferenceDate - today!.timeIntervalSinceReferenceDate)/3600/24
    let price = info.newPrice
    
    switch diffDays {
    case ...0: return (0, 0)
    case 1: return (50, price / 2)
    case 2...4: return (70, price * 7 / 10)
    case 5...7: return (90, price * 9 / 10)
    default: return (100, price)
    }
}
 
