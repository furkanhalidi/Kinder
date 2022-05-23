//
//  Typealiases.swift
//  Kinder
//
//  Created by 508853 on 10.05.2022.
//

import Foundation
import DefaultNetworkOperationPackage

typealias LoginResultBlock = (Result<LoginResponseModel, ErrorResponse>) -> Void
typealias CurrentUserBlock = (Result<CurrentUserResponseModel, ErrorResponse>) -> Void
typealias MedicineListBlock = (Result<[Medicine], ErrorResponse>) -> Void
typealias DuesListBlock = (Result<[Dues], ErrorResponse>) -> Void
