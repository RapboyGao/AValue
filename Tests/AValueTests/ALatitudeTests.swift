@testable import AValue
import XCTest

class ALatitudeTests: XCTestCase {
    func testCoordinate60AutoIncrement() throws {
        let latitude = ALatitude.degrees(isNorth: true, degrees: 2 + 59 / 60 + 59.96 / 3600)
        XCTAssert(latitude.toDMS().toString(digits: 1) == "N03°00'00.0\"")
    }

    func testToString() {
        let latitude = ALatitude.degrees(isNorth: true, degrees: 2 + 3 / 60 + 4 / 3600)
        XCTAssertEqual(latitude.toD().toString(digits: 5), "N02.05111°")
        XCTAssertEqual(latitude.toDM().toString(digits: 1), "N02°03.1'")
        XCTAssertEqual(latitude.toDMS().toString(digits: 1), "N02°03'04.0\"")
    }

    func testDegreesFormat() {
        // 测试 degrees 格式，如 N39.26165°
        let latitude1 = ALatitude("N39.26165°")
        XCTAssertEqual(latitude1?.toNumber(), 39.26165)

        let latitude2 = ALatitude("S39.26165°")
        XCTAssertEqual(latitude2?.toNumber(), -39.26165)
    }

    func testDegreesMinutesFormat() {
        // 测试 degrees 和 minutes 格式，如 N39°16.5'
        let latitude1 = ALatitude("N39°16.5'")
        XCTAssertEqual(latitude1?.toNumber(), 39.275)

        let latitude2 = ALatitude("S39°16.5'")
        XCTAssertEqual(latitude2?.toNumber(), -39.275)
    }

    func testDegreesMinutesSecondsFormat() {
        // 测试 degrees, minutes 和 seconds 格式，如 N39°16'53.33"
        let latitude1 = ALatitude("N39°16'53.33\"")
        XCTAssertEqual(latitude1, .degreesMinutesSeconds(isNorth: true, degrees: 39, minutes: 16, seconds: 53.33))

        let latitude2 = ALatitude("S39°16'53.33\"")
        XCTAssertEqual(latitude2, .degreesMinutesSeconds(isNorth: false, degrees: 39, minutes: 16, seconds: 53.33))
    }

    func testOriginalFormatDegreesMinutes() {
        // 测试原始 degrees 和 minutes 格式，如 N39165 -> N39°16.5'
        let latitude1 = ALatitude("N39165")
        XCTAssertEqual(latitude1?.toNumber(), 39.275)

        let latitude2 = ALatitude("S39165")
        XCTAssertEqual(latitude2?.toNumber(), -39.275)
    }

    func testOriginalFormatDegreesMinutesDecimal() {
        // 测试原始 degrees 和小数形式的 minutes 格式，如 S3916.55 -> S39°16.55'
        let latitude1 = ALatitude("S3916.55")
        XCTAssertEqual(latitude1?.toNumber(), -39.27583333333333)

        let latitude2 = ALatitude("N3916.55")
        XCTAssertEqual(latitude2?.toNumber(), 39.27583333333333)
    }

    func testOriginalFormatDegreesMinutesSeconds() {
        // 测试原始 degrees, minutes 和 seconds 格式，如 S381653 -> S38°16'53"
        let latitude1 = ALatitude("S381653")
        XCTAssertEqual(latitude1?.toNumber(), -38.28138888888889)

        let latitude2 = ALatitude("N381653")
        XCTAssertEqual(latitude2?.toNumber(), 38.28138888888889)
    }

    func testOriginalFormatDegreesMinutesSecondsDecimal() {
        // 测试原始 degrees, minutes 和 seconds 带小数点格式，如 S381653.3 -> S38°16'53.3"
        let latitude1 = ALatitude("S381653.3")
        XCTAssertEqual(latitude1?.toNumber(), -38.28147222222222)

        let latitude2 = ALatitude("N381653.3")
        XCTAssertEqual(latitude2?.toNumber(), 38.28147222222222)
    }

    func testOriginalFormatDegreesWithDecimal() {
        // 测试原始 degrees 带小数点格式，如 S39.26165 -> S39.26165°
        let latitude1 = ALatitude("S39.26165")
        XCTAssertEqual(latitude1?.toNumber(), -39.26165)

        let latitude2 = ALatitude("N39.26165")
        XCTAssertEqual(latitude2?.toNumber(), 39.26165)
    }

    func testInvalidInput() {
        // 测试无效输入
        XCTAssertNil(ALatitude(nil)) // 空输入
        XCTAssertNil(ALatitude("")) // 空字符串
        XCTAssertNil(ALatitude("39.26165")) // 无方向符号
        XCTAssertNil(ALatitude("X39.26165")) // 非法方向符号
        XCTAssertNil(ALatitude("N39°16.5")) // 格式错误
    }
}
