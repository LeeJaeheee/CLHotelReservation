//
//  main.swift
//  Lv1
//
//  Created by 이재희 on 2023/07/20.
//

import Foundation

var choice = "0"
var balance = 0

repeat {
    print(programMsg)
    choice = readLine()!
    switch choice {
    case "1":
        let rand = Int.random(in: 100000...500000)
        balance += rand
        print("\t\(rand)원이 입금되었습니다")
    case "2":
        print(msg2)
    default: break
    }
} while choice != "0"
            
            
