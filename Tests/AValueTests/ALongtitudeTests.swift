@testable import AValue
import XCTest

@available(macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, *)
class ALongitudeTests: XCTestCase {
    // 测试自动进位功能
    func testCoordinate60AutoIncrement() throws {
        let longitude = ALongitude.degrees(isEast: true, degrees: 2.0 + 59.0 / 60.0 + 59.96 / 3600.0)
        XCTAssertEqual(longitude.toDMS().toString(digits: 1), "E003°00'00.0\"")
    }
    
    // 测试不同格式的字符串输出
    func testToString() throws {
        let longitude = ALongitude.degrees(isEast: true, degrees: 2.0 + 3.0 / 60.0 + 4.0 / 3600.0)
        XCTAssertEqual(longitude.toD().toString(digits: 5), "E002.05111°")
        XCTAssertEqual(longitude.toDM().toString(digits: 1), "E002°03.1'")
        XCTAssertEqual(longitude.toDMS().toString(digits: 1), "E002°03'04.0\"")
    }
    
    // 测试纯度数格式
    func testDegreesFormat() throws {
        let longitude1 = try ALongitude("E39.26165°")
        XCTAssertEqual(longitude1.toNumber(), 39.26165)
        
        let longitude2 = try ALongitude("W39.26165°")
        XCTAssertEqual(longitude2.toNumber(), -39.26165)
    }
    
    // 测试度分格式
    func testDegreesMinutesFormat() throws {
        let longitude1 = try ALongitude("E39°16.5'")
        XCTAssertEqual(longitude1.toNumber(), 39.275)
        
        let longitude2 = try ALongitude("W39°16.5'")
        XCTAssertEqual(longitude2.toNumber(), -39.275)
    }
    
    // 测试度分秒格式
    func testDegreesMinutesSecondsFormat() throws {
        let longitude1 = try ALongitude("E39°16'53.33\"")
        XCTAssertEqual(longitude1, .degreesMinutesSeconds(isEast: true, degrees: 39, minutes: 16, seconds: 53.33))
        
        let longitude2 = try ALongitude("W39°16'53.33\"")
        XCTAssertEqual(longitude2, .degreesMinutesSeconds(isEast: false, degrees: 39, minutes: 16, seconds: 53.33))
    }
    
    // 测试原始度分格式
    func testOriginalFormatDegreesMinutes() throws {
        let longitude1 = try ALongitude("E039165")
        XCTAssertEqual(longitude1.toNumber(), 39.275)
        
        let longitude2 = try ALongitude("W039165")
        XCTAssertEqual(longitude2.toNumber(), -39.275)
    }
    
    // 测试原始度分小数格式
    func testOriginalFormatDegreesMinutesDecimal() throws {
        let longitude1 = try ALongitude("W03916.55")
        XCTAssertEqual(longitude1, .degreesMinutes(isEast: false, degrees: 39, minutes: 16.55))
        
        let longitude2 = try ALongitude("E13916.55")
        XCTAssertEqual(longitude2, .degreesMinutes(isEast: true, degrees: 139, minutes: 16.55))
    }
    
    // 测试原始度分秒格式
    func testOriginalFormatDegreesMinutesSeconds() throws {
        let longitude1 = try ALongitude("W1381653")
        XCTAssertEqual(longitude1, .degreesMinutesSeconds(isEast: false, degrees: 138, minutes: 16, seconds: 53))
        
        let longitude2 = try ALongitude("E0381653")
        XCTAssertEqual(longitude2, .degreesMinutesSeconds(isEast: true, degrees: 38, minutes: 16, seconds: 53))
    }
    
    // 测试原始度分秒小数格式
    func testOriginalFormatDegreesMinutesSecondsDecimal() throws {
        let longitude1 = try ALongitude("W1381653.3")
        XCTAssertEqual(longitude1, .degreesMinutesSeconds(isEast: false, degrees: 138, minutes: 16, seconds: 53.3))
        
        let longitude2 = try ALongitude("E0381653.3")
        XCTAssertEqual(longitude2, .degreesMinutesSeconds(isEast: true, degrees: 38, minutes: 16, seconds: 53.3))
    }
    
    // 测试原始纯度数小数格式
    func testOriginalFormatDegreesWithDecimal() throws {
        let longitude1 = try ALongitude("W39.26165")
        XCTAssertEqual(longitude1.toNumber(), -39.26165)
        
        let longitude2 = try ALongitude("E39.26165")
        XCTAssertEqual(longitude2.toNumber(), 39.26165)
    }

    // 测试边界值
    func testBoundaryValues() throws {
        let longitude1 = try ALongitude("E180°00'00\"")
        XCTAssertEqual(longitude1.toNumber(), 180.0)
        
        let longitude2 = try ALongitude("W180°00'00\"")
        XCTAssertEqual(longitude2.toNumber(), -180.0)
        
        let longitude3 = try ALongitude("E000°00'00\"")
        XCTAssertEqual(longitude3.toNumber(), 0.0)
    }
    
    // 测试转换方法
    func testConversionMethods() throws {
        let longitude = ALongitude.degrees(isEast: false, degrees: 123.456)
        XCTAssertEqual(longitude.toD().toNumber(), -123.456)
        XCTAssertEqual(longitude.toDM().toNumber(), -123.456)
        XCTAssertEqual(longitude.toDMS().toNumber(), -123.456)
    }
}
