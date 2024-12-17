@testable import AValue
import XCTest

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
class ALatitudeTests: XCTestCase {
    func testCoordinate60AutoIncrement() throws {
        let latitude = ALatitude.degrees(isNorth: true, degrees: 2 + 59 / 60 + 59.96 / 3600)
        XCTAssert(latitude.toDMS().toString(digits: 1) == "N03°00'00.0\"")
    }

    func testToString() throws {
        let latitude = ALatitude.degrees(isNorth: true, degrees: 2 + 3 / 60 + 4 / 3600)
        XCTAssertEqual(latitude.toD().toString(digits: 5), "N02.05111°")
        XCTAssertEqual(latitude.toDM().toString(digits: 1), "N02°03.1'")
        XCTAssertEqual(latitude.toDMS().toString(digits: 1), "N02°03'04.0\"")
    }

    func testDegreesFormat() throws {
        // 测试 degrees 格式，如 N39.26165°
        let latitude1 = try ALatitude("N39.26165°")
        XCTAssertEqual(latitude1.toNumber(), 39.26165)

        let latitude2 = try ALatitude("S39.26165°")
        XCTAssertEqual(latitude2.toNumber(), -39.26165)
    }

    func testDegreesMinutesFormat() throws {
        // 测试 degrees 和 minutes 格式，如 N39°16.5'
        let latitude1 = try ALatitude("N39°16.5'")
        XCTAssertEqual(latitude1.toNumber(), 39.275)

        let latitude2 = try ALatitude("S39°16.5'")
        XCTAssertEqual(latitude2.toNumber(), -39.275)
    }

    func testDegreesMinutesSecondsFormat() throws {
        // 测试 degrees, minutes 和 seconds 格式，如 N39°16'53.33"
        let latitude1 = try ALatitude("N39°16'53.33\"")
        XCTAssertEqual(latitude1, .degreesMinutesSeconds(isNorth: true, degrees: 39, minutes: 16, seconds: 53.33))

        let latitude2 = try ALatitude("S39°16'53.33\"")
        XCTAssertEqual(latitude2, .degreesMinutesSeconds(isNorth: false, degrees: 39, minutes: 16, seconds: 53.33))
    }

    func testOriginalFormatDegreesMinutes() throws {
        // 测试原始 degrees 和 minutes 格式，如 N39165 -> N39°16.5'
        let latitude1 = try ALatitude("N39165")
        XCTAssertEqual(latitude1.toNumber(), 39.275)

        let latitude2 = try ALatitude("S39165")
        XCTAssertEqual(latitude2.toNumber(), -39.275)
    }

    func testOriginalFormatDegreesMinutesDecimal() throws {
        // 测试原始 degrees 和小数形式的 minutes 格式，如 S3916.55 -> S39°16.55'
        let latitude1 = try ALatitude("S3916.55")
        XCTAssertEqual(latitude1.toNumber(), -39.27583333333333)

        let latitude2 = try ALatitude("N3916.55")
        XCTAssertEqual(latitude2.toNumber(), 39.27583333333333)
    }

    func testOriginalFormatDegreesMinutesSeconds() throws {
        // 测试原始 degrees, minutes 和 seconds 格式，如 S381653 -> S38°16'53"
        let latitude1 = try ALatitude("S381653")
        XCTAssertEqual(latitude1.toNumber(), -38.28138888888889)

        let latitude2 = try ALatitude("N381653")
        XCTAssertEqual(latitude2.toNumber(), 38.28138888888889)
    }

    func testOriginalFormatDegreesMinutesSecondsDecimal() throws {
        // 测试原始 degrees, minutes 和 seconds 带小数点格式，如 S381653.3 -> S38°16'53.3"
        let latitude1 = try ALatitude("S381653.3")
        XCTAssertEqual(latitude1.toNumber(), -38.28147222222222)

        let latitude2 = try ALatitude("N381653.3")
        XCTAssertEqual(latitude2.toNumber(), 38.28147222222222)
    }

    func testOriginalFormatDegreesWithDecimal() throws {
        // 测试原始 degrees 带小数点格式，如 S39.26165 -> S39.26165°
        let latitude1 = try ALatitude("S39.26165")
        XCTAssertEqual(latitude1.toNumber(), -39.26165)

        let latitude2 = try ALatitude("N39.26165")
        XCTAssertEqual(latitude2.toNumber(), 39.26165)
    }

    func testInvalidInput() throws {
        // 测试无效输入
        XCTAssertNil(try? ALatitude(nil)) // 空输入
        XCTAssertNil(try? ALatitude("")) // 空字符串
        XCTAssertNil(try? ALatitude("39.26165")) // 无方向符号
        XCTAssertNil(try? ALatitude("X39.26165")) // 非法方向符号
        XCTAssertNil(try? ALatitude("N39°16.5")) // 格式错误
    }

    func testNonStandardFormat() throws {
        XCTAssertNil(try? ALatitude("39°16'53.33\"N")) // 方向符号在末尾
        XCTAssertNil(try? ALatitude("N39°16'53\".33")) // 错误的小数点位置
    }

    func testBoundaryValues() throws {
        let latitude1 = try ALatitude("N90°00'00\"")
        XCTAssertEqual(latitude1.toNumber(), 90.0)

        let latitude2 = try ALatitude("S90°00'00\"")
        XCTAssertEqual(latitude2.toNumber(), -90.0)

        let latitude3 = try ALatitude("N00°00'00\"")
        XCTAssertEqual(latitude3.toNumber(), 0.0)
    }
}
