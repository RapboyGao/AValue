@testable import AValue
import SwiftUI
import XCTest

@available(iOS 16, macOS 12.0, tvOS 15.0, watchOS 8.0, *)
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

    func testParseAHourMinuteExpression() throws {
        let expression = "1235-150"
        let value: [AHourMinuteValue]? = .init(expression)
        XCTAssertEqual(value?.sum(format: .hourMinute), .hourMinute(isNegative: false, hour: 10, minute: 45))
    }

    func testColorEqual() throws {
        let color = Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.3)
        let value = AValue(color: color)
        XCTAssertEqual(color, value?.getColor())
    }
}
