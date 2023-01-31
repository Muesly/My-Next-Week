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
    func testDayButtonPress() throws {
        let subject = AddActionViewModel(eventStore: MockEventStore())
        subject.dayButtonPressed(0, completion: { success in
            XCTAssertTrue(success)
        })
    }
}

class MockEventStore: EventStorable {
    func authorizationStatus() -> EKAuthorizationStatus {
        return .authorized
    }

    func requestAccess(completion: @escaping (Bool) -> Void) {
        completion(true)
    }

    func createEvent() -> EKEvent {
        return EKEvent()
    }

    var calendars: [EKCalendar] = []
}
