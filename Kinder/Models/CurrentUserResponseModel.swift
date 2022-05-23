//
//  CurrentUserResponseModel.swift
//  Kinder
//
//  Created by 508853 on 14.05.2022.
//

import Foundation

struct CurrentUserResponseModel: Codable {
    let id: String
    let userName: String
    let firstName: String
    let lastName: String
    let phone: String
    let email: String
    let role: String
    let schoolNumber: String
}
