//
//  Date+Extension.swift
//  Kinder
//
//  Created by 508853 on 21.05.2022.
//

import Foundation

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
