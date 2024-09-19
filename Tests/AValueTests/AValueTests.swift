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

    // 测试各种字符串输入的初始化
    func testInitFromString() throws {
        // 测试 "130" 或 "0130" 格式
        XCTAssertEqual(AHourMinuteValue(string: "130"), .hourMinute(isNegative: false, hour: 1, minute: 30))
        XCTAssertEqual(AHourMinuteValue(string: "0130"), .hourMinute(isNegative: false, hour: 1, minute: 30))

        // 测试 "321:23" 或 "32123" 格式
        XCTAssertEqual(AHourMinuteValue(string: "321:23"), .hourMinute(isNegative: false, hour: 321, minute: 23))
        XCTAssertEqual(AHourMinuteValue(string: "32123"), .hourMinute(isNegative: false, hour: 321, minute: 23))

        // 测试单个数字作为分钟的情况
        XCTAssertEqual(AHourMinuteValue(string: "3"), .totalMinutes(isNegative: false, totalMinutes: 3))
        XCTAssertEqual(AHourMinuteValue(string: "12"), .totalMinutes(isNegative: false, totalMinutes: 12))

        // 测试 "3:" 作为小时
        XCTAssertEqual(AHourMinuteValue(string: "3:"), .hourMinute(isNegative: false, hour: 3, minute: 0))

        // 测试 ":2" 作为分钟
        XCTAssertEqual(AHourMinuteValue(string: ":2"), .hourMinute(isNegative: false, hour: 0, minute: 2))

        // 测试负数输入
        XCTAssertEqual(AHourMinuteValue(string: "-130"), .hourMinute(isNegative: true, hour: 1, minute: 30))
        XCTAssertEqual(AHourMinuteValue(string: "-321:23"), .hourMinute(isNegative: true, hour: 321, minute: 23))
        XCTAssertEqual(AHourMinuteValue(string: "+321:23"), .hourMinute(isNegative: false, hour: 321, minute: 23))

        // 测试包含天数的输入
        XCTAssertEqual(AHourMinuteValue(string: "130+1d"), .days24HM(day: 1, hour: 1, minute: 30))
        XCTAssertEqual(AHourMinuteValue(string: "-124+2d"), .days24HM(day: 1, hour: 22, minute: 36))
        XCTAssertEqual(AHourMinuteValue(string: "+1d"), .days24HM(day: 1, hour: 0, minute: 0))

        print(AHourMinuteValue.days24HM(day: 0, hour: 2, minute: 31))
    }

    func testALatitudeInitialization() {
        // 测试格式: N39165 -> N39°16.5'
        if case let .degreesMinutes(isNorth, degrees, minutes) = ALatitude("N39165") {
            XCTAssertTrue(isNorth)
            XCTAssertEqual(degrees, 39)
            XCTAssertEqual(minutes, 16.5, accuracy: 0.1)
        } else {
            XCTFail("Failed to initialize ALatitude with format N39165")
        }

        if case let .degreesMinutes(isNorth, degrees, minutes) = ALatitude("S39165") {
            XCTAssertFalse(isNorth)
            XCTAssertEqual(degrees, 39)
            XCTAssertEqual(minutes, 16.5, accuracy: 0.1)
        } else {
            XCTFail("Failed to initialize ALatitude with format S39165")
        }

        // 测试格式: N3916.55 -> N39°16.55'
        if case let .degreesMinutes(isNorth, degrees, minutes) = ALatitude("N3916.55") {
            XCTAssertTrue(isNorth)
            XCTAssertEqual(degrees, 39)
            XCTAssertEqual(minutes, 16.55, accuracy: 0.01)
        } else {
            XCTFail("Failed to initialize ALatitude with format N3916.55")
        }

        if case let .degreesMinutes(isNorth, degrees, minutes) = ALatitude("S3916.55") {
            XCTAssertFalse(isNorth)
            XCTAssertEqual(degrees, 39)
            XCTAssertEqual(minutes, 16.55, accuracy: 0.01)
        } else {
            XCTFail("Failed to initialize ALatitude with format S3916.55")
        }

        // 测试格式: N381653 -> N38°16'53"
        if case let .degreesMinutesSeconds(isNorth, degrees, minutes, seconds) = ALatitude("N381653") {
            XCTAssertTrue(isNorth)
            XCTAssertEqual(degrees, 38)
            XCTAssertEqual(minutes, 16)
            XCTAssertEqual(seconds, 53)
        } else {
            XCTFail("Failed to initialize ALatitude with format N381653")
        }

        if case let .degreesMinutesSeconds(isNorth, degrees, minutes, seconds) = ALatitude("S381653") {
            XCTAssertFalse(isNorth)
            XCTAssertEqual(degrees, 38)
            XCTAssertEqual(minutes, 16)
            XCTAssertEqual(seconds, 53)
        } else {
            XCTFail("Failed to initialize ALatitude with format S381653")
        }

        // 测试格式: N3816533 -> N38°16'53.3"
        if case let .degreesMinutesSeconds(isNorth, degrees, minutes, seconds) = ALatitude("N3816533") {
            XCTAssertTrue(isNorth)
            XCTAssertEqual(degrees, 38)
            XCTAssertEqual(minutes, 16)
            XCTAssertEqual(seconds, 53.3, accuracy: 0.1)
        } else {
            XCTFail("Failed to initialize ALatitude with format N3816533")
        }

        if case let .degreesMinutesSeconds(isNorth, degrees, minutes, seconds) = ALatitude("S3816533") {
            XCTAssertFalse(isNorth)
            XCTAssertEqual(degrees, 38)
            XCTAssertEqual(minutes, 16)
            XCTAssertEqual(seconds, 53.3, accuracy: 0.1)
        } else {
            XCTFail("Failed to initialize ALatitude with format S3816533")
        }

        // 测试格式: N381653.3 -> N38°16'53.3"
        if case let .degreesMinutesSeconds(isNorth, degrees, minutes, seconds) = ALatitude("N381653.3") {
            XCTAssertTrue(isNorth)
            XCTAssertEqual(degrees, 38)
            XCTAssertEqual(minutes, 16)
            XCTAssertEqual(seconds, 53.3, accuracy: 0.01)
        } else {
            XCTFail("Failed to initialize ALatitude with format N381653.3")
        }

        if case let .degreesMinutesSeconds(isNorth, degrees, minutes, seconds) = ALatitude("S381653.3") {
            XCTAssertFalse(isNorth)
            XCTAssertEqual(degrees, 38)
            XCTAssertEqual(minutes, 16)
            XCTAssertEqual(seconds, 53.3, accuracy: 0.01)
        } else {
            XCTFail("Failed to initialize ALatitude with format S381653.3")
        }

        // 测试格式: N39.26165 -> N39.26165°
        if case let .degrees(isNorth, degrees) = ALatitude("N39.26165") {
            XCTAssertTrue(isNorth)
            XCTAssertEqual(degrees, 39.26165, accuracy: 0.00001)
        } else {
            XCTFail("Failed to initialize ALatitude with format N39.26165")
        }

        if case let .degrees(isNorth, degrees) = ALatitude("S39.26165") {
            XCTAssertFalse(isNorth)
            XCTAssertEqual(degrees, 39.26165, accuracy: 0.00001)
        } else {
            XCTFail("Failed to initialize ALatitude with format S39.26165")
        }

        // 测试无效格式
        if let _ = ALatitude("InvalidFormat") {
            XCTFail("Initialization should have failed for invalid format")
        }
    }

    func testCoordinate60AutoIncrement() throws {
        let latitude = ALatitude.degrees(isNorth: true, degrees: 2 + 59 / 60 + 59.96 / 3600)
        XCTAssert(latitude.toDMS().toString(digits: 1) == "N03°00'00.0\"")
    }

    func testHMDescription() throws {
        for timeValue in [1552, -1552, 35, -20] {
            let time = AHourMinuteValue(minutes: timeValue)
            print(time.toHM(), time.toDHM(), time.toTotalHours(), time.toTotalMinutes())
        }
    }
}
