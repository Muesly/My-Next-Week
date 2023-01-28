//
//  AddActionViewModel.swift
//  MyNextWeek
//
//  Created by Tony Short on 28/01/2023.
//

import EventKit
import SwiftUI

class AddActionViewModel {
    let eventStore = EKEventStore()
    var actionDayIndex: Int = 0

    func dayButtonPressed(_ index: Int, completion: @escaping ((Bool) -> ())) {
        checkCalendarAuthorizationStatus { [weak self] authorized in
            self?.actionDayIndex = index
            guard authorized else {
                completion(false)
                return
            }
            completion(true)
        }
    }

    private func checkCalendarAuthorizationStatus(completion: @escaping (Bool) -> Void) {
        let eventStore = EKEventStore();
        let status = EKEventStore.authorizationStatus(for: EKEntityType.event)
        switch (status) {
        case .notDetermined:
            eventStore.requestAccess(to: EKEntityType.event, completion: { (accessGranted: Bool, error: Error?) in
                if accessGranted == true {
                    DispatchQueue.main.async(execute: {
                        completion(true)
                    })
                }
            })
        case .authorized:
            DispatchQueue.main.async(execute: {
                completion(true)
            })
        default:
            completion(false)
        }
    }

    private func actionDate(for actionDayIndex: Int) -> Date {
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
        let startOfWeek = gregorian.date(byAdding: .day, value: 8, to: sunday)
        return Calendar.current.date(byAdding: .day, value: actionDayIndex, to: startOfWeek!)!
    }

    func createEvent(actionText: String) -> EKEvent {
        let newEvent = EKEvent(eventStore: eventStore)
        let calendars = eventStore.calendars(for: .event)
        newEvent.calendar = calendars.first { $0.title == "Tony's calendar"}
        newEvent.title = actionText
        newEvent.isAllDay = true
        let date = actionDate(for: actionDayIndex)
        newEvent.startDate = date
        newEvent.endDate = date
        return newEvent
    }
}
