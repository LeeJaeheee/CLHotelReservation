//
//  inoutData.swift
//  Lv4
//
//  Created by 이재희 on 2023/07/21.
//

import Foundation

var inoutData: [(choice: String, price: Int)] = []

func showInout() {
    for (i, val) in inoutData.enumerated() {
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
