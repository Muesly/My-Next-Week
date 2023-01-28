//
//  AddActionView.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import SwiftUI

struct AddActionView: View {
    enum FocusedField {
        case actionText
    }

    private let actionType: ActionType
    private let viewModel: AddActionViewModel
    @State var actionText: String = ""
    @State var isShowingCalenderScreen = false
    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FocusedField?

    init(actionType: ActionType, viewModel: AddActionViewModel) {
        self.actionType = actionType
        self.viewModel = viewModel
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                TextField("", text: $actionText)
                    .padding()
                    .background(Color(red: 0.1, green: 0.1, blue: 0.1))
                    .focused($focusedField, equals: .actionText)
                    .onAppear {
                        if actionType.nameAsDefault {
                            self.actionText = actionType.name   // Fill in text
                        } else {
                            focusedField = .actionText  // Bring up keyboard ot ask for text
                        }
                    }
                Text("Create on which day next week?")
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                HStack {
                    ForEach(Day.allCases, id: \.rawValue) { day in
                        DayButton(day: day) {
                            viewModel.dayButtonPressed($0) { success in
                                isShowingCalenderScreen = success
                            }
                        }
                    }
                }
                Spacer()
            }.padding()
            .navigationTitle(actionType.name)
            .sheet(isPresented: $isShowingCalenderScreen) {
                dismiss()
            } content: {
                EventEditView(eventStore: viewModel.eventStore, event: viewModel.createEvent(actionText: actionText))
            }
        }
    }
}
