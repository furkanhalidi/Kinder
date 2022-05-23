//
//  UserDefaultsManage.swift
//  Kinder
//
//  Created by 508853 on 9.05.2022.
//

import Foundation

class UserDefaultsManager {
    func saveValue(key: String, value: Any?) {
        UserDefaults.standard.setValue(value, forKey: key)
    }
    
    func getValue(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
}
