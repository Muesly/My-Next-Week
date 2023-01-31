//
//  DayButton.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import SwiftUI

struct DayButton: View {
    let date: Date
    let onClick: (Int) -> Void
    let nf = NumberFormatter()

    init(date: Date, onClick: @escaping (Int) -> Void) {
        self.date = date
        self.onClick = onClick
        nf.numberStyle = .ordinal
    }

    var weekday: Int {
        Calendar.current.component(.weekday, from: date) - 1
    }

    var day: Day {
        Day.allCases[weekday]
    }

    var body: some View {
        let dateComponents = Calendar.current.component(.day, from: date)
        let dayNumber = nf.string(from: dateComponents as NSNumber)!
        let dateString = "\(day.rawValue.capitalized) \(dayNumber)"
        Button(dateString, action: {
            onClick(weekday)
        })
        .frame(maxWidth: .infinity)
        .padding(EdgeInsets(top: 8, leading: 7, bottom: 8, trailing: 7))
        .background(Color("backgroundSecondary"))
        .cornerRadius(10)
    }
}

enum Day: String, CaseIterable {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
}
