//
//  ActionType.swift
//  MyNextWeek
//
//  Created by Tony Short on 29/01/2023.
//

import Foundation

struct ActionType: Identifiable, Hashable, Codable {
    let id: UUID
    let typeString: String
    let prefillActionWithTypeString: Bool
    let isAtARegularTime: Bool
    let defaultTime: Date?
    let duration: Int?
    
    init(id: UUID = UUID(),
         name: String,
         prefill: Bool = true,
         isAtARegularTime: Bool = false,
         defaultTime: Date? = nil,
         duration: Int? = nil
    ) {
        self.id = id
        self.typeString = name
        self.prefillActionWithTypeString = prefill
        self.isAtARegularTime = isAtARegularTime
        self.defaultTime = defaultTime
        self.duration = duration
    }
}
