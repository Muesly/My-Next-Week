//
//  EventType.swift
//  MyNextWeek
//
//  Created by Tony Short on 01/02/2023.
//

import EventKit
import Foundation

protocol EventType {
    var calendarChoice: EKCalendar? { get set }
    var titleStr: String? { get set }
    var allDayIndicator: Bool { get set }
    var eventStartDate: Date? { get set }
    var eventEndDate: Date? { get set }
}

extension EKEvent: EventType {
    var calendarChoice: EKCalendar? {
        get {
            calendar
        }
        set {
            calendar = newValue
        }
    }

    var titleStr: String? {
        get {
            title
        }
        set {
            title = newValue
        }
    }

    var allDayIndicator: Bool {
        get {
            isAllDay
        }
        set {
            isAllDay = newValue
        }
    }

    var eventStartDate: Date? {
        get {
            startDate
        }
        set {
            startDate = newValue
        }
    }

    var eventEndDate: Date? {
        get {
            endDate
        }
        set {
            endDate = newValue
        }
    }
}
