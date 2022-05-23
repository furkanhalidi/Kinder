//
//  LoginResponseModel.swift
//  Kinder
//
//  Created by 508853 on 10.05.2022.
//

import Foundation

struct LoginResponseModel: Codable {
    let accessToken: String
    let tokenType: String
    let refreshToken: String
    let expires: Int
    let scope: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case tokenType = "token_type"
        case refreshToken = "refresh_token"
        case expires = "expires_in"
        case scope = "scope"
    }
}
