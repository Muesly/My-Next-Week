//
//  DayButton.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import SwiftUI

struct DayButton: View {
    let day: Day
    let onClick: (Int) -> Void

    init(day: Day, onClick: @escaping (Int) -> Void) {
        self.day = day
        self.onClick = onClick
    }

    func dayString() -> String {
        day.rawValue.capitalized
    }

    func dayIndexInWeek() -> Int {
        return Day.allCases.firstIndex(of: day) ?? 0
    }

    var body: some View {
        Button(dayString(), action: {
            onClick(dayIndexInWeek())
        })
        .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
        .background(Color(red: 0.1, green: 0.1, blue: 0.1))
    }
}

enum Day: String, CaseIterable {
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    case sun
}
