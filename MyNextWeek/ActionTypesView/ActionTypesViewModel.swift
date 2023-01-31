//
//  ActionTypesViewModel.swift
//  MyNextWeek
//
//  Created by Tony Short on 29/01/2023.
//

import SwiftUI

class ActionTypesViewModel: ObservableObject {
    @Published var dimensions: [ActionDimension]

    init(dimensions: [ActionDimension] = [.physical, .planning, .social, .spiritual, .mental]) {
        self.dimensions = dimensions
        dimensions.forEach { $0.loadActions() }
    }

    func addNewActionType(id: UUID = UUID(),
                          dimension: ActionDimension?,
                          name: String,
                          prefil: Bool,
                          isAtARegularTime: Bool,
                          defaultTime: Date?,
                          duration: Int?) {
        guard let foundDimension = dimensions.first(where: { $0 == dimension }) else {
            return
        }
        foundDimension.actionTypes.append(ActionType(id: id,
                                                     name: name,
                                                     prefill: prefil,
                                                     isAtARegularTime: isAtARegularTime,
                                                     defaultTime: defaultTime,
                                                     duration: duration))
        foundDimension.saveActions()
        self.objectWillChange.send()
    }

    func removeActionType(atOffsets offsets: IndexSet, inDimension dimension: ActionDimension) {
        guard let foundDimension = dimensions.first(where: { $0 == dimension }),
              offsets.count == 1,
              let offsetToDelete = offsets.first else {
            return
        }
        foundDimension.actionTypes.remove(at: offsetToDelete)
        foundDimension.saveActions()
        self.objectWillChange.send()
    }
}

