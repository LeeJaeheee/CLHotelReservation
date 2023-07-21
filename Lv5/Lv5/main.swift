//
//  main.swift
//  Lv5
//
//  Created by 이재희 on 2023/07/21.
//

import Foundation

typealias Reservation = (roomNum: String, checkin: String, checkout: String, price: Int, newPrice: Int)
typealias InoutData = [(choice: String, price: Int)]

let dateFormatter = DateFormatter()
dateFormatter.dateFormat = "YYYY-MM-dd"

var isLogin = false

var choice = "0"
var myInfo: UserInfo
let inputError = "입력이 올바르지 않습니다"

print(loginMsg)
let userName = readLine()!
userList[userName] = UserInfo(userName: userName)
myInfo = userList[userName]!
isLogin = true

repeat {
    if !isLogin {
        print(loginMsg)
        let userName = readLine()!
        if userList.keys.contains(userName) {
            myInfo = userList[userName]!
        } else {
            userList[userName] = UserInfo(userName: userName)
            myInfo = userList[userName]!
        }
        isLogin = true
        continue
    }
    
    print(programMsg)
    choice = readLine()!
    
    switch choice {
    case "0": break
    case "1":
        let rand = Int.random(in: 100000...500000)
        myInfo.balance += rand
        print("\t\(rand)원이 입금되었습니다")
        myInfo.inoutData.append(("1", rand))
    case "2":
        for (k, v) in roomInfo.sorted(by: {$0.0 < $1.0}) {
            print("\t\(k)번방 1박 \(v)원")
        }
    case "3":
        var info: Reservation
        
        print(msg3)
        print("방 번호를 입력하세요")
        guard let roomNum = readLine() else { print(inputError); break }
        if !roomInfo.keys.contains(roomNum) {
            print("오류: 방 번호가 존재하지 않습니다")
            break
        }
        
        print("체크인 날짜를 입력하세요 ex)2023-07-20")
        guard let checkin = readLine(), let checkinDate = dateFormatter.date(from: checkin) else { print(inputError); break }
        let todayStr = dateFormatter.string(from: Date())
        let today = dateFormatter.date(from: todayStr)
        if checkinDate < today! {
            print("오류: 체크인 날짜가 올바르지 않습니다")
            break
        }
        
        print("체크아웃 날짜를 입력하세요 ex)2023-07-22")
        guard let checkout = readLine(), let checkoutDate = dateFormatter.date(from: checkout) else { print(inputError); break }
        if checkinDate >= checkoutDate {
            print("오류: 체크아웃 날짜가 올바르지 않습니다")
            break
        }

        let diffDays = Int(checkoutDate.timeIntervalSinceReferenceDate-checkinDate.timeIntervalSinceReferenceDate)/3600/24

        guard var price = roomInfo[roomNum] else { print(inputError); break }
        price = myInfo.isPremium ? price * 8 / 10 : price
        let newPrice = price * diffDays
        if newPrice > myInfo.balance {
            print("오류: 잔금이 부족합니다")
            break
        }
        
        info = (roomNum, checkin, checkout, price, newPrice)
        myInfo.reservationList.append(info)
        myInfo.balance -= newPrice
        if myInfo.isPremium {
            print("프리미엄 회원 혜택으로 20% 할인된 \(newPrice)원이 출금됩니다")
        } else if diffDays >= 10 {
            // 현재 프리미엄 회원이 아니고 10일 이상 숙박 예약 완료한 경우 다음번 예약부터 20% 할인
            myInfo.isPremium = true
            print("프리미엄 회원으로 승급되셨습니다. 이후 예약에 대해서 20% 할인이 적용됩니다")
        }
        print("예약이 완료되었습니다")
        myInfo.inoutData.append(("3", newPrice))

    case "4":
        for (i, r) in myInfo.reservationList.enumerated() {
            print("\(i+1). \(r.roomNum)번방 체크인: \(r.checkin), 체크아웃: \(r.checkout), 1박가격: \(r.price)")
        }
    case "5":
        for (i, r) in myInfo.reservationList.sorted(by: {$0.checkin < $1.checkin}).enumerated() {
            print("\(i+1). \(r.roomNum)번방 체크인: \(r.checkin), 체크아웃: \(r.checkout), 1박가격: \(r.price)")
        }
    case "6":
        for (i, r) in myInfo.reservationList.enumerated() {
            print("\(i+1). \(r.roomNum)번방 체크인: \(r.checkin), 체크아웃: \(r.checkout), 1박가격: \(r.price)")
        }
        print("\n취소할 예약 번호를 입력하세요")
        guard let num = Int(readLine()!) else { print(inputError); break }
        if !(1...myInfo.reservationList.count ~= num) {
            print("오류: 예약 번호가 올바르지 않습니다")
            break
        }
        let refund = calcRefund(info: myInfo.reservationList[num-1])
        myInfo.balance += refund.1
        myInfo.reservationList.remove(at: num-1)
        print("\(num)번 예약이 취소되었습니다")
        print("환불 정책에 따라 \(refund.0)%인 \(refund.1)원이 환불되었습니다")
        myInfo.inoutData.append(("6", refund.1))
    case "7":
        for (i, r) in myInfo.reservationList.enumerated() {
            print("\(i+1). \(r.roomNum)번방 체크인: \(r.checkin), 체크아웃: \(r.checkout), 1박가격: \(r.price)")
        }
        
        print("\n변경할 예약 번호를 입력하세요")
        guard let num = Int(readLine()!) else { print(inputError); break }
        if !(1...myInfo.reservationList.count ~= num) {
            print("오류: 예약 번호가 올바르지 않습니다")
            break
        }
        
        print("변경할 방 번호를 입력하세요")
        guard let roomNum = readLine() else { print(inputError); break }
        if !roomInfo.keys.contains(roomNum) || myInfo.reservationList[num-1].roomNum == roomNum {
            print("오류: 방 번호가 올바르지 않습니다")
            break
        }
        
        let preInfo = myInfo.reservationList[num-1]
        let newPrice = preInfo.newPrice / preInfo.price * roomInfo[roomNum]!
        let diff = preInfo.newPrice - newPrice
        
        if diff > myInfo.balance {
            print("오류: 잔금이 부족합니다")
            break
        }
        myInfo.balance += diff
        myInfo.reservationList[num-1].roomNum = roomNum
        myInfo.reservationList[num-1].price = roomInfo[roomNum]!
        myInfo.reservationList[num-1].newPrice = newPrice
        print("\(num)번 예약이 변경되었습니다")
        myInfo.inoutData.append(("7", diff))
    case "8":
        showInout(userData: myInfo.inoutData)
    case "9":
        print("잔액은 \(myInfo.balance.formatted())원 입니다")
    case "10":
        print("현재 사용자 계정 로그아웃 합니다")
        isLogin = false
    default: print(inputError); break
    }
} while choice != "0"

