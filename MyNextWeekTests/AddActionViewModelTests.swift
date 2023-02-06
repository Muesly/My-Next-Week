//
//  AddActionViewModelTests.swift
//  MyNextWeekTests
//
//  Created by Tony Short on 31/01/2023.
//

import EventKit
import SwiftUI
import XCTest

@testable import MyNextWeek

final class AddActionViewModelTests: XCTestCase {
    func testDayButtonPressWhenAuthorized() throws {
        let expectation = XCTestExpectation()
        let subject = AddActionViewModel(eventStore: MockEventStore())
        subject.dayButtonPressed(0, completion: { success in
            XCTAssertTrue(success)
            XCTAssertFalse(subject.shouldShowCalendarPermissionAlert)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testDayButtonPressWhenNotDeterminedThenAuthorized() throws {
        let expectation = XCTestExpectation()
        let mockEventStore = MockEventStore()
        mockEventStore.authorizationStatusToReturn = .notDetermined
        mockEventStore.accessGranted = true

        let subject = AddActionViewModel(eventStore: mockEventStore)
        subject.dayButtonPressed(0, completion: { success in
            XCTAssertTrue(success)
            XCTAssertFalse(subject.shouldShowCalendarPermissionAlert)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testDayButtonPressWhenNotDeterminedThenDenied() throws {
        let expectation = XCTestExpectation()
        let mockEventStore = MockEventStore()
        mockEventStore.authorizationStatusToReturn = .notDetermined
        mockEventStore.accessGranted = false

        let subject = AddActionViewModel(eventStore: mockEventStore)
        subject.dayButtonPressed(0, completion: { success in
            XCTAssertFalse(success)
            XCTAssertTrue(subject.shouldShowCalendarPermissionAlert)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testDayButtonPressWhenUnauthorized() throws {
        let expectation = XCTestExpectation()
        let mockEventStore = MockEventStore()
        mockEventStore.authorizationStatusToReturn = .denied
        let subject = AddActionViewModel(eventStore: mockEventStore)
        subject.dayButtonPressed(0, completion: { success in
            XCTAssertFalse(success)
            XCTAssertTrue(subject.shouldShowCalendarPermissionAlert)
            expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1)
    }

    func testCreateMondayEventOnASundayAddsOnNextDay() throws {
        let subject = AddActionViewModel(eventStore: MockEventStore())
        subject.actionDayIndex = 0
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = 2023
        dateComponents.month = 2
        dateComponents.day = 5
        let date = dateComponents.date!
        let event = subject.createEvent(actionType: ActionType(name: "Go for a walk"),
                                        actionText: "Go for a walk",
                                        calendarName: "",
                                        currentDate: date)
        XCTAssertEqual(event.allDayIndicator, true)
        XCTAssertEqual(event.titleStr, "Go for a walk")
        XCTAssertEqual(event.calendarChoice, nil)
        XCTAssertEqual(event.eventStartDate, date.addingTimeInterval(1 * 86400))
        XCTAssertEqual(event.eventEndDate, date.addingTimeInterval(1 * 86400))
    }

    // Thursday is last day where we may schedule for a request for a Thursday event to be added as today.
    func testCreateThursdayEventOnAThursdayAddsOnSameDay() throws {
        let subject = AddActionViewModel(eventStore: MockEventStore())
        subject.actionDayIndex = 3
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = 2023
        dateComponents.month = 2
        dateComponents.day = 2
        let date = dateComponents.date!
        let event = subject.createEvent(actionType: ActionType(name: "Go for a walk"),
                                        actionText: "Go for a walk",
                                        calendarName: "",
                                        currentDate: date)
        XCTAssertEqual(event.eventStartDate, date.addingTimeInterval(0))
        XCTAssertEqual(event.eventEndDate, date.addingTimeInterval(0))
    }

    // Test Friday creates on next week (time we may be thinking about following week, not this one
    func testCreateTuesdayEventOnAFridayAddsOnNextWeek() throws {
        let subject = AddActionViewModel(eventStore: MockEventStore())
        subject.actionDayIndex = 1
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = 2023
        dateComponents.month = 2
        dateComponents.day = 3
        let date = dateComponents.date!
        let event = subject.createEvent(actionType: ActionType(name: "Go for a walk"),
                                        actionText: "Go for a walk",
                                        calendarName: "",
                                        currentDate: date)
        let offset: TimeInterval = 4 * 86400
        XCTAssertEqual(event.eventStartDate, date.addingTimeInterval(offset))
        XCTAssertEqual(event.eventEndDate, date.addingTimeInterval(offset))
    }

    func testCreateMondayEventOnAParticularTime() throws {
        let subject = AddActionViewModel(eventStore: MockEventStore())
        subject.actionDayIndex = 0
        var dateComponents = DateComponents()
        dateComponents.calendar = Calendar.current
        dateComponents.year = 2023
        dateComponents.month = 2
        dateComponents.day = 6
        let date = dateComponents.date!

        var timeComponents = DateComponents()
        timeComponents.calendar = Calendar.current
        timeComponents.hour = 9
        timeComponents.minute = 30
        let defaultTime = timeComponents.date!
        let event = subject.createEvent(actionType: ActionType(name: "Go for a walk", isAtARegularTime: true, defaultTime: defaultTime, duration: 30),
                                        actionText: "Go for a walk",
                                        calendarName: "",
                                        currentDate: date)
        XCTAssertEqual(event.allDayIndicator, false)
        XCTAssertEqual(event.eventStartDate, date.addingTimeInterval((9 * 3600) + (30 * 60)))
        XCTAssertEqual(event.eventEndDate, date.addingTimeInterval(10 * 3600))
    }

}

class MockEventStore: EventStorable {
    var authorizationStatusToReturn: EKAuthorizationStatus = .authorized
    var accessGranted = false

    func authorizationStatus() -> EKAuthorizationStatus {
        return authorizationStatusToReturn
    }

    func requestAccess(completion: @escaping (Bool) -> Void) {
        completion(accessGranted)
    }

    func createEvent() -> EventType {
        return MockEvent()
    }

    var calendars: [EKCalendar] = []
}

struct MockEvent: EventType {
    var calendarChoice: EKCalendar?

    var titleStr: String?

    var allDayIndicator: Bool = true

    var eventStartDate: Date?

    var eventEndDate: Date?


}
