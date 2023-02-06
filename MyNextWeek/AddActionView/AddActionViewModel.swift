//
//  AddActionViewModel.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import EventKit
import SwiftUI

class AddActionViewModel: ObservableObject {
    @Published var shouldShowCalendarPermissionAlert = false
    @Published var shouldShowConfirmationAlert = false

    let eventStore: EventStorable
    var actionDayIndex: Int = 0

    init(eventStore: EventStorable = EKEventStore()) {
        self.eventStore = eventStore
    }

    func dayButtonPressed(_ index: Int, completion: @escaping ((Bool) -> ())) {
        checkCalendarAuthorizationStatus { [weak self] authorized in
            self?.actionDayIndex = index
            guard authorized else {
                self?.shouldShowCalendarPermissionAlert = true
                completion(false)
                return
            }
            completion(true)
        }
    }

    private func checkCalendarAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        switch (eventStore.authorizationStatus()) {
        case .notDetermined:
            eventStore.requestAccess { (accessGranted: Bool) in
                DispatchQueue.main.async(execute: {
                    completion(accessGranted)
                })
            }
        case .authorized:
            DispatchQueue.main.async(execute: {
                completion(true)
            })
        default:
            completion(false)
        }
    }

    private func actionDate(for actionDayIndex: Int, from currentDate: Date) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: currentDate))!

        let diff = Calendar.current.dateComponents([.day], from: sunday, to: currentDate)
        var offset: Int = 0
        if diff.day! <= 4 {
            offset = 1  // Sunday or Monday, then just move to Monday
        } else {
            offset = 8  // Move to following Monday
        }
        let startOfWeek = gregorian.date(byAdding: .day, value: offset, to: sunday)

        return Calendar.current.date(byAdding: .day, value: actionDayIndex, to: startOfWeek!)!
    }

    func createEvent(actionType: ActionType,
                     actionText: String,
                     calendarName: String,
                     currentDate: Date = Date()) -> EventType {
        var newEvent = eventStore.createEvent()
        let calendars = eventStore.calendars
        let chosenCalendar = calendars.first { $0.title == calendarName}
        newEvent.calendarChoice = chosenCalendar
        newEvent.titleStr = actionText
        if actionType.isAtARegularTime,
           let defaultTime = actionType.defaultTime {
            newEvent.allDayIndicator = false

            var date = actionDate(for: actionDayIndex, from: currentDate)
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: defaultTime)
            let minutes = calendar.component(.minute, from: defaultTime)
            date.addTimeInterval(TimeInterval((hour * 3600) + (minutes * 60)))
            newEvent.eventStartDate = date
            newEvent.eventEndDate = date + TimeInterval((actionType.duration ?? 60) * 60)
        } else {
            newEvent.allDayIndicator = true
            let date = actionDate(for: actionDayIndex, from: currentDate)
            newEvent.eventStartDate = date
            newEvent.eventEndDate = date
        }
        return newEvent
    }

    var calendarNames: [String] {
        let calendars = eventStore.calendars
        return calendars.filter { $0.allowsContentModifications }.map { $0.title }
    }

    let defaultCalendarNameKey = "Default Calendar Name"
    var defaultCalendarName: String {
        get {
            guard let defaultCalendarName = UserDefaults.standard.string(forKey: defaultCalendarNameKey) else {
                return calendarNames.first ?? ""
            }
            return defaultCalendarName
        }
        set {
            UserDefaults.standard.set(newValue, forKey: defaultCalendarNameKey)
        }
    }

    var dates: [Date] {
        (0...7).map { Date().addingTimeInterval(TimeInterval(Int($0) * 86400)) }
    }
}
