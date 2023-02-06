//
//  ActionTypesViewModel.swift
//  MyNextWeek
//
//  Created by Tony Short on 29/01/2023.
//

import SwiftUI

class ActionTypesViewModel: ObservableObject {
    @Published var categories: [ActionCategory]

    init(categories: [ActionCategory] = [.physical, .planning, .social, .spiritual, .mental]) {
        self.categories = categories
        categories.forEach { $0.loadActions() }
    }

    func addNewActionType(id: UUID = UUID(),
                          category: ActionCategory?,
                          name: String,
                          prefil: Bool,
                          isAtARegularTime: Bool,
                          defaultTime: Date?,
                          duration: Int?) {
        guard let foundCategory = categories.first(where: { $0 == category }) else {
            return
        }
        foundCategory.actionTypes.append(ActionType(id: id,
                                                    name: name,
                                                    prefill: prefil,
                                                    isAtARegularTime: isAtARegularTime,
                                                    defaultTime: defaultTime,
                                                    duration: duration))
        foundCategory.saveActions()
        self.objectWillChange.send()
    }

    func removeActionType(atOffsets offsets: IndexSet, inCategory category: ActionCategory) {
        guard let foundCategory = categories.first(where: { $0 == category }),
              offsets.count == 1,
              let offsetToDelete = offsets.first else {
            return
        }
        foundCategory.actionTypes.remove(at: offsetToDelete)
        foundCategory.saveActions()
        self.objectWillChange.send()
    }
}

