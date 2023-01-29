//
//  ActionTypesViewModel.swift
//  MyNextWeek
//
//  Created by Tony Short on 29/01/2023.
//

import SwiftUI

public class ActionTypesViewModel: ObservableObject {
    @Published var dimensions: [ActionDimension] = [.physical, .planning, .social, .spiritual, .mental]

    public init() {
        dimensions.forEach { $0.loadActions() }
    }

    func addNewActionType(dimension: ActionDimension?, name: String, prefil: Bool) {
        guard let foundDimension = dimensions.first(where: { $0 == dimension }) else {
            return
        }
        foundDimension.actionTypes.append(ActionType(name: name, prefill: prefil))
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

