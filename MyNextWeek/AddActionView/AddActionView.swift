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
    @StateObject private var viewModel: AddActionViewModel = AddActionViewModel()
    @State var actionText: String = ""

    @State var isShowingCalenderScreen = false
    @State var shouldShowConfirmationAlert = false

    @Environment(\.dismiss) private var dismiss
    @FocusState private var focusedField: FocusedField?
    @State private var chosenCalendarName: String = ""

    init(actionType: ActionType) {
        self.actionType = actionType
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                TextField("", text: $actionText)
                    .padding()
                    .background(Color("backgroundSecondary"))
                    .cornerRadius(10)
                    .focused($focusedField, equals: .actionText)
                    .onAppear {
                        if actionType.prefillActionWithTypeString {
                            self.actionText = actionType.typeString   // Fill in text
                        } else {
                            focusedField = .actionText  // Bring up keyboard ot ask for text
                        }
                    }
                Text("Add to which calendar?")
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                Picker("Add to which calendar?", selection: $chosenCalendarName) {
                    ForEach(viewModel.calendarNames, id: \.self) { calendarName in
                        Text(calendarName).tag(calendarName)
                    }
                    .pickerStyle(.automatic)
                }
                Text("Create on which day next week?")
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 5, trailing: 0))
                VStack {
                    HStack {
                        ForEach(viewModel.dates[0...3], id: \.self) { date in
                            DayButton(date: date) {
                                viewModel.dayButtonPressed($0) { success in
                                    isShowingCalenderScreen = success
                                }
                            }
                        }
                    }
                    HStack {
                        ForEach(viewModel.dates[4...7], id: \.self) { date in
                            DayButton(date: date) {
                                viewModel.dayButtonPressed($0) { success in
                                    isShowingCalenderScreen = success
                                }
                            }
                        }
                    }
                }
                Spacer()
            }.padding()
            .navigationTitle(actionType.typeString)
            .onAppear() {
                chosenCalendarName = viewModel.defaultCalendarName
            }
            .sheet(isPresented: $isShowingCalenderScreen) {
                dismiss()
                shouldShowConfirmationAlert = true
                viewModel.defaultCalendarName = chosenCalendarName
            } content: {
                EventEditView(eventStore: viewModel.eventStore, event: viewModel.createEvent(actionType: actionType,
                                                                                             actionText: actionText,
                                                                                             calendarName: chosenCalendarName))
            }
            .alert(isPresented: $shouldShowConfirmationAlert, content: {
                Alert(title: Text("Added to your calendar!"))
            })
            .alert(isPresented: $viewModel.shouldShowCalendarPermissionAlert, content: {
                Alert(title: Text("No access to your calendar"))
            })
        }
    }
}
