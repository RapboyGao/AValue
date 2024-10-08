@testable import AValue
import XCTest

final class AValueTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }

    func testCoordinateValue() throws {
        let latitude = ALatitude.degrees(isNorth: true, degrees: 2 + 3 / 60 + 4 / 3600)
        XCTAssert(latitude.toD().toString(digits: 5) == "N02.05111°")
        XCTAssert(latitude.toDM().toString(digits: 1) == "N02°03.1'")
        XCTAssert(latitude.toDMS().toString(digits: 1) == "N02°03'04.0\"")
        let longitude = ALongitude(-latitude.toNumber())
        XCTAssert(longitude.toD().toString(digits: 5) == "W002.05111°")
        XCTAssert(longitude.toDM().toString(digits: 1) == "W002°03.1'")
        XCTAssert(longitude.toDMS().toString(digits: 1) == "W002°03'04.0\"")
    }

    func testHMDescription() throws {
        for timeValue in [1552, -1552, 35, -20] {
            let time = AHourMinuteValue(minutes: timeValue)
            print(time.toHM(), time.toDHM(), time.toTotalHours(), time.toTotalMinutes())
        }
    }

    func testParseAHourMinuteExpression() throws {
        let expression = "1235-150"
        let value: [AHourMinuteValue]? = .init(expression)
        print(value?.sum(format: .hourMinute))
    }
}
