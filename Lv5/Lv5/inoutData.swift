//
//  inoutData.swift
//  Lv5
//
//  Created by 이재희 on 2023/07/21.
//

import Foundation

func showInout(userData: InoutData) {
    for (i, val) in userData.enumerated() {
        switch val.choice {
        case "1": print("\(i+1). 랜덤으로 \(val.price)원 입금")
        case "3": print("\(i+1). 예약으로 \(val.price)원 출금")
        case "6": print("\(i+1). 환불금으로 \(val.price)원 입금")
        case "7":
            print("\(i+1). 차액으로",terminator: " ")
            val.price > 0 ? print("\(val.price)원 입금") : print("\(-val.price)원 출금")
        default: break
        }
    }
}
