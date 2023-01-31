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
    @State var newActionTypeDimension: ActionDimension?
    @State var isAtARegularTime = false
    @State var defaultTime = Date()
    @State var duration: Int = 60

    init(viewModel: ActionTypesViewModel) {
        self.viewModel = viewModel
    }

    public var body: some View {
        NavigationStack {
            List(viewModel.dimensions) { actionDimension in
                Section(header: Text(actionDimension.name)) {
                    Text(actionDimension.description).font(.subheadline)
                    ForEach(actionDimension.actionTypes) { actionType in
                        NavigationLink {
                            AddActionView(actionType: actionType, viewModel: AddActionViewModel())
                        } label: {
                            Text(actionType.typeString)
                        }
                    }
                    .onDelete { indexSet in
                        viewModel.removeActionType(atOffsets: indexSet, inDimension: actionDimension)
                    }
                    NavigationLink {
                        AddActionTypeView(chosenDimension: actionDimension,
                                          actionTypeDimension: $newActionTypeDimension,
                                          actionTypeText: $newActionTypeText,
                                          prefillActionWithTypeString: $newActionTypePrefil,
                                          actionTypeTextSaved: $newActionTypeTextSaved,
                                          isAtARegularTime: $isAtARegularTime,
                                          defaultTime: $defaultTime,
                                          duration: $duration)
                    } label: {
                        Text("Add new \(actionDimension.name) action")
                            .foregroundColor(.gray)
                    }
                }.listRowBackground(actionDimension.colour.opacity(0.3))
            }
            .navigationTitle("My Next Week")
            .background(Color("backgroundPrimary"))
        }
        .onChange(of: newActionTypeTextSaved) { saved in
            if saved {
                viewModel.addNewActionType(dimension: newActionTypeDimension,
                                           name: newActionTypeText,
                                           prefil: newActionTypePrefil,
                                           isAtARegularTime: isAtARegularTime,
                                           defaultTime: isAtARegularTime ? defaultTime : nil,
                                           duration: isAtARegularTime ? duration : nil)
            }
        }
    }
}
