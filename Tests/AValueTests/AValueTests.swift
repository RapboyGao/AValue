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
        let latitude = ACoordinateValue.latitude(isNorth: true, degrees: 2 + 3 / 60 + 4 / 3600)
        XCTAssert(latitude.toD().toString(digits: 5) == "N02.05111°")
        XCTAssert(latitude.toDM().toString(digits: 1) == "N02°03.1'")
        XCTAssert(latitude.toDMS().toString(digits: 1) == "N02°03'04.0\"")
        let longitude = ACoordinateValue(longitude: -latitude.toNumber())
        XCTAssert(longitude.toD().toString(digits: 5) == "W002.05111°")
        XCTAssert(longitude.toDM().toString(digits: 1) == "W002°03.1'")
        XCTAssert(longitude.toDMS().toString(digits: 1) == "W002°03'04.0\"")
    }

    func testCoordinate60AutoIncrement() throws {
        let latitude = ACoordinateValue.latitude(isNorth: true, degrees: 2 + 59 / 60 + 59.96 / 3600)
        XCTAssert(latitude.toDMS().toString(digits: 1) == "N03°00'00.0\"")
    }

    func testHMDescription() throws {
        for timeValue in [1552, -1552, 35, -20] {
            let time = AHourMinuteValue(minutes: timeValue)
            print(time.toHM(), time.toDHM(), time.toTotalHours(), time.toTotalMinutes())
        }
    }
}
