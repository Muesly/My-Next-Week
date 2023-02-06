//
//  MyNextWeekTests.swift
//  MyNextWeekTests
//
//  Created by Tony Short on 31/01/2023.
//

import SwiftUI
import XCTest

@testable import MyNextWeek

final class MyNextWeekTests: XCTestCase {
    let uuid = UUID(uuidString: "E621E1F8-C36C-495A-93FC-0C247A3E6E5F")!

    func testAddNewActionType() throws {
        let testCategory = ActionCategory(name: "Physical",
                                  description: "Etc.",
                                  colour: Color("babyBlue"),
                                  defaultActionTypes: [],
                                  userDefaults: MockUserDefaults())
        let subject = ActionTypesViewModel(categories: [testCategory])
        XCTAssertEqual(testCategory.actionTypes, [])
        subject.addNewActionType(id: uuid,
                                 category: .physical,
                                 name: "Go to gym",
                                 prefil: false,
                                 isAtARegularTime: false,
                                 defaultTime: nil,
                                 duration: nil)
        XCTAssertEqual(testCategory.actionTypes, [ActionType(id: uuid,
                                                              name: "Go to gym",
                                                              prefill: false,
                                                              isAtARegularTime: false)])
    }

    func testRemoveActionType() {
        let testCategory = ActionCategory(id: uuid,
                                            name: "Physical",
                                            description: "Etc.",
                                            colour: Color("babyBlue"),
                                            defaultActionTypes: [],
                                            userDefaults: MockUserDefaults())
        let subject = ActionTypesViewModel(categories: [testCategory])
        subject.addNewActionType(id: uuid,
                                 category: .physical,
                                 name: "Go to gym",
                                 prefil: false,
                                 isAtARegularTime: false,
                                 defaultTime: nil,
                                 duration: nil)

        XCTAssertEqual(testCategory.actionTypes.count, 1)
        subject.removeActionType(atOffsets: IndexSet(integer: 0), inCategory: testCategory)
        XCTAssertEqual(testCategory.actionTypes.count, 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }

}

class MockUserDefaults: UserDefaultsType {
    func value(forKey key: String) -> Any? {
        return Data()
    }
}
