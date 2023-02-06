//
//  ActionTypesView.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import SwiftUI

struct ActionTypesView: View {
    @ObservedObject private var viewModel: ActionTypesViewModel
    @State var newActionTypeText = ""
    @State var newActionTypePrefil = false
    @State var newActionTypeTextSaved = false
    @State var newActionTypeCategory: ActionCategory?
    @State var isAtARegularTime = false
    @State var defaultTime = Date()
    @State var duration: Int = 60

    init(viewModel: ActionTypesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            List(viewModel.categories) { actionCategory in
                Section(header: Text(actionCategory.name)) {
                    Text(actionCategory.description).font(.subheadline)
                    ForEach(actionCategory.actionTypes) { actionType in
                        NavigationLink {
                            AddActionView(actionType: actionType)
                        } label: {
                            Text(actionType.typeString)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.removeActionType(atOffsets: indexSet, inCategory: actionCategory)
                    }
                    NavigationLink {
                        AddActionTypeView(chosenCategory: actionCategory,
                                          actionTypeCategory: $newActionTypeCategory,
                                          actionTypeText: $newActionTypeText,
                                          prefillActionWithTypeString: $newActionTypePrefil,
                                          actionTypeTextSaved: $newActionTypeTextSaved,
                                          isAtARegularTime: $isAtARegularTime,
                                          defaultTime: $defaultTime,
                                          duration: $duration)
                    } label: {
                        Text("Add new \(actionCategory.name) action")
                            .foregroundColor(.gray)
                    }
                }.listRowBackground(actionCategory.colour.opacity(0.3))
            }
            .navigationTitle("My Next Week")
            .background(Color("backgroundPrimary"))
        }
        .onChange(of: newActionTypeTextSaved) { saved in
            if saved {
                viewModel.addNewActionType(category: newActionTypeCategory,
                                           name: newActionTypeText,
                                           prefil: newActionTypePrefil,
                                           isAtARegularTime: isAtARegularTime,
                                           defaultTime: isAtARegularTime ? defaultTime : nil,
                                           duration: isAtARegularTime ? duration : nil)
            }
        }
    }
}
