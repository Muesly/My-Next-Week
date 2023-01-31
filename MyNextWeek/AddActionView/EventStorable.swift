//
//  EventStorable.swift
//  MyNextWeek
//
//  Created by Tony Short on 31/01/2023.
//

import Foundation
import EventKit

protocol EventStorable {
    func authorizationStatus() -> EKAuthorizationStatus
    func requestAccess(completion: @escaping (_ granted: Bool) -> Void)
    func createEvent() -> EKEvent

    var calendars: [EKCalendar] { get }
}

extension EKEventStore: EventStorable {
    func authorizationStatus() -> EKAuthorizationStatus {
        EKEventStore.authorizationStatus(for: EKEntityType.event)
    }

    func requestAccess(completion: @escaping (_ granted: Bool) -> Void) {
        requestAccess(to: EKEntityType.event) { granted, _ in
            completion(granted)
        }
    }

    func createEvent() -> EKEvent {
        EKEvent(eventStore: self)
    }

    var calendars: [EKCalendar] {
        return calendars(for: .event)
    }
}
