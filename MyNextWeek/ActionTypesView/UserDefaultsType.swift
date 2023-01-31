//
//  UserDefaultsType.swift
//  MyNextWeek
//
//  Created by Tony Short on 31/01/2023.
//

import Foundation

protocol UserDefaultsType {
    func value(forKey key: String) -> Any?
}

extension UserDefaults: UserDefaultsType {}
