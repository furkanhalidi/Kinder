//
//  Medicine.swift
//  Kinder
//
//  Created by 508853 on 21.05.2022.
//

import Foundation

struct Medicine: Codable {
    let id: String
    let medicineName: String
    let date: String
    let hour: String
    let isUsed: Bool
}

struct PostMedicine: Codable {
    let medicineName: String
    let isUsed: Bool
    let description: String
}
