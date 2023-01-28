//
//  ActionTypesView.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import SwiftUI

struct ActionType: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let nameAsDefault: Bool

    init(name: String, nameAsDefault: Bool = true) {
        self.name = name
        self.nameAsDefault = nameAsDefault
    }
}

struct ActionTypesView: View {
    let actions: [ActionDimension]

    init() {
        actions = [.physical, .planning, .social, .spiritual, .mental]
    }

    var body: some View {
        NavigationStack {
            List(actions) { actionDimension in
                Section(header: Text(actionDimension.name)) {
                    Text(actionDimension.description).font(.subheadline)
                    ForEach(actionDimension.actionTypes) { actionType in
                        NavigationLink {
                            AddActionView(actionType: actionType, viewModel: AddActionViewModel())
                        } label: {
                            Text(actionType.name)
                        }
                    }
                }
            }
            .navigationTitle("My Next Week")
        }
    }
}
