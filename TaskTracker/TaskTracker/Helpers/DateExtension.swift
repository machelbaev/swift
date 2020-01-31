//
//  DateExtension.swift
//  TaskTracker
//
//  Created by Mikhail on 31.01.2020.
//  Copyright © 2020 Mikhail. All rights reserved.
//

import UIKit

extension Date {

    func timeAgoDisplayRussian() -> String {
        let str = dateFormatter.string(from: self)
        if self.timeIntervalSinceNow > 0 {
            return "будет \(str)"
        } else if self.timeIntervalSinceNow > -120 {
            return "только что"
        } else if self.timeIntervalSinceNow > -60*5 {
            let mins = (-Int(self.timeIntervalSinceNow) / 60)
            return "\(mins) минуты назад"
        } else if Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: Date()) && self.timeIntervalSinceNow > -60*60*24 {
            let df = DateFormatter()
            df.locale = Locale(identifier: "Rus")
            df.dateFormat = "HH:mm"
            return "сегодня в \(df.string(from: self))"
        } else if Calendar.current.component(.day, from: self) == Calendar.current.component(.day, from: Date())-1 && self.timeIntervalSinceNow > -60*60*48 {
            let df = DateFormatter()
            df.locale = Locale(identifier: "Rus")
            df.dateFormat = "HH:mm"
            return "вчера в \(df.string(from: self))"
        } else {
            return str
        }
    }
}


fileprivate let dateFormatter = { () -> DateFormatter in
    let df = DateFormatter()
    df.locale = Locale(identifier: "Rus")
    df.dateFormat = "d MMMM в HH:mm"
    return df
}()
