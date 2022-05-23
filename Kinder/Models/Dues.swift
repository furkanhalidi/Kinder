//
//  Dues.swift
//  Kinder
//
//  Created by 508853 on 21.05.2022.
//

import Foundation

struct Dues: Codable {
    let id: String?
    let date: String
    let paymentDate: String
    let value: Float
    let isPaid: Bool
}
