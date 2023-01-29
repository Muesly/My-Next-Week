//
//  ActionType.swift
//  MyNextWeek
//
//  Created by Tony Short on 29/01/2023.
//

import Foundation

struct ActionType: Identifiable, Hashable, Codable {
    var id = UUID()
    let typeString: String
    let prefillActionWithTypeString: Bool

    init(name: String, prefill: Bool = true) {
        self.typeString = name
        self.prefillActionWithTypeString = prefill
    }
}
