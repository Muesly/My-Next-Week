//
//  AddActionTypeView.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import SwiftUI

struct AddActionTypeView: View {
    enum FocusedField {
        case actionTypeText
    }

    let chosenDimension: ActionDimension
    @Binding var actionTypeDimension: ActionDimension?
    @Binding var actionTypeText: String
    @Binding var prefillActionWithTypeString: Bool
    @Binding var actionTypeTextSaved: Bool
    @Binding var isAtARegularTime: Bool
    @Binding var defaultTime: Date
    @Binding var duration: Int

    @FocusState private var focusedField: FocusedField?
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 10) {
                TextField("", text: $actionTypeText)
                    .padding()
                    .background(Color("backgroundSecondary"))
                    .cornerRadius(10)
                    .focused($focusedField, equals: .actionTypeText)
                    .onAppear {
                        focusedField = .actionTypeText  // Bring up keyboard ot ask for text
                        actionTypeDimension = chosenDimension
                        actionTypeText = ""
                        actionTypeTextSaved = false
                        prefillActionWithTypeString = true
                    }
                    .onSubmit {
                        if !actionTypeText.isEmpty {
                            dismiss()
                            actionTypeTextSaved = true
                        }
                    }
                Toggle("When adding new action, prefill with above string?", isOn: $prefillActionWithTypeString)
                Toggle("Set a regular time?", isOn: $isAtARegularTime)
                if isAtARegularTime {
                    DatePicker("Default time for action", selection: $defaultTime, displayedComponents: .hourAndMinute)
                    HStack {
                        Text("Duration")
                        Spacer()
                        HStack {
                            TextField("", value: $duration, formatter: NumberFormatter())
                                .frame(width: 35, height: 35)
                                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 8))
                                .background(Color("backgroundSecondary"))
                                .cornerRadius(10)
                            Text("mins")
                        }
                    }
                }
                Spacer()
            }
            .padding()
            .foregroundColor(Color("foregroundPrimary"))
            .navigationTitle(chosenDimension.name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        dismiss()
                        actionTypeTextSaved = true
                    }
                    .disabled(actionTypeText.isEmpty)
                }
            }
        }
    }
}
