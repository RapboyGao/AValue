@testable import AValue
import XCTest

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
class ALongitudeTests: XCTestCase {
    func testCoordinate60AutoIncrement() throws {
        let latitude = ALongitude.degrees(isEast: true, degrees: 2 + 59 / 60 + 59.96 / 3600)
        XCTAssert(latitude.toDMS().toString(digits: 1) == "E003°00'00.0\"")
    }

    func testToString() throws {
        let latitude = ALongitude.degrees(isEast: false, degrees: 2 + 3 / 60 + 4 / 3600)
        XCTAssertEqual(latitude.toD().toString(digits: 5), "W002.05111°")
        XCTAssertEqual(latitude.toDM().toString(digits: 1), "W002°03.1'")
        XCTAssertEqual(latitude.toDMS().toString(digits: 1), "W002°03'04.0\"")
    }

    func testParseOriginalFormat() throws {
        for _ in 0 ... 10 {
            let number = Double.random(in: -90 ... 90)
            for format in ACoordinateFormat.allCases {
                let value = ALongitude(number, format: format)
                let parsed = try ALongitude(value.toString(digits: 20))
                XCTAssertEqual(value.toNumber(), parsed.toNumber())
            }
        }
    }

    func testDifferentFormat() throws {
        // 6 + decimal digits
        var string = "N0391315.3"
        var latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutesSeconds(isEast: true, degrees: 39, minutes: 13, seconds: 15.3))

        string = "S0391315.3"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutesSeconds(isEast: false, degrees: 39, minutes: 13, seconds: 15.3))

        // 7 digits
        string = "N03913153"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutesSeconds(isEast: true, degrees: 39, minutes: 13, seconds: 15.3))

        // 6 digits
        string = "N0391315"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutesSeconds(isEast: true, degrees: 39, minutes: 13, seconds: 15))

        // 4 + deicimal digits
        string = "N03913.2"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutes(isEast: true, degrees: 39, minutes: 13.2))

        // 5 digits
        string = "N039131"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutes(isEast: true, degrees: 39, minutes: 13.1))

        // 4 digits
        string = "N03913"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degreesMinutes(isEast: true, degrees: 39, minutes: 13))

        // 3 digits (Faulty)
        string = "N0391"
        XCTAssertNil(try? ALongitude(string))

        // 2 digits
        string = "N039"
        latitude = try ALongitude(string)
        XCTAssertEqual(latitude, .degrees(isEast: true, degrees: 39))
    }

    func testDifferentFormatIsSame() throws {
        // 6 + decimal digits
        XCTAssertEqual(try ALongitude("N0123456.7"), try ALongitude("N012°34'56.7\""))

        // 7 digits
        XCTAssertEqual(try ALongitude("N01234567"), try ALongitude("N012°34'56.7\""))

        // 6 digits
        XCTAssertEqual(try ALongitude("N0123456"), try ALongitude("N012°34'56\""))

        // 4 + deicimal digits
        XCTAssertEqual(try ALongitude("N01234.5"), try ALongitude("N012°34.5'"))

        // 5 digits
        XCTAssertEqual(try ALongitude("N012345"), try ALongitude("N012°34.5'"))

        // 4 digits
        XCTAssertEqual(try ALongitude("N01234"), try ALongitude("N012°34.0'"))

        // 3 digits (Faulty)

        // 2 digits
        XCTAssertEqual(try ALongitude("N012"), try ALongitude("N012°"))
    }

    func testInvalidInput() throws {
        // 测试无效输入
        XCTAssertNil(try? ALongitude(nil)) // 空输入
        XCTAssertNil(try? ALongitude("")) // 空字符串
        XCTAssertNil(try? ALongitude("39.26165")) // 无方向符号
        XCTAssertNil(try? ALongitude("X39.26165")) // 非法方向符号
        XCTAssertNil(try? ALongitude("N039°16.5")) // 格式错误
    }

    func testNonStandardFormat() throws {
        XCTAssertNil(try? ALongitude("39°16'53.33\"N0")) // 方向符号在末尾
        XCTAssertNil(try? ALongitude("N039°16'53\".33")) // 错误的小数点位置
    }

    func testBoundaryValues() throws {
        let latitude1 = try ALongitude("N090°00'00\"")
        XCTAssertEqual(latitude1.toNumber(), 90.0)

        let latitude2 = try ALongitude("S090°00'00\"")
        XCTAssertEqual(latitude2.toNumber(), -90.0)

        let latitude3 = try ALongitude("N000°00'00\"")
        XCTAssertEqual(latitude3.toNumber(), 0.0)

        let latitude4 = try ALongitude("S000°00'00\"")
        XCTAssertEqual(latitude4.toNumber(), 0.0)
    }
}
