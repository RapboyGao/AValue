@testable import AValue
import SwiftUI
import XCTest

@available(iOS 14.0, macOS 11, tvOS 14.0, watchOS 7.0, *)
final class AColorTests: XCTestCase {
    // 测试自定义RGB颜色转换
    func testCustomRGBColorConversion() throws {
        // 测试不同RGB值的自定义颜色
        let customColors: [(Double, Double, Double, Double)] = [
            (1.0, 0.0, 0.0, 1.0), // 纯红
            (0.0, 1.0, 0.0, 1.0), // 纯绿
            (0.0, 0.0, 1.0, 1.0), // 纯蓝
            (0.5, 0.5, 0.5, 1.0), // 灰色
            (1.0, 1.0, 0.0, 1.0), // 黄色
            (1.0, 0.0, 1.0, 1.0), // 品红
            (0.0, 1.0, 1.0, 1.0), // 青色
            (0.3, 0.4, 0.5, 1.0) // 自定义色
        ]
        
        for (r, g, b, a) in customColors {
            let color = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
            let aColor = try XCTUnwrap(AColor(color), "Failed to convert custom color (R:\(r), G:\(g), B:\(b), A:\(a)) to AColor")
            // 验证AColor的RGB值是否与原始值匹配
            XCTAssertEqual(aColor.red, r, accuracy: 0.01, "Red component mismatch")
            XCTAssertEqual(aColor.green, g, accuracy: 0.01, "Green component mismatch")
            XCTAssertEqual(aColor.blue, b, accuracy: 0.01, "Blue component mismatch")
            XCTAssertEqual(aColor.alpha, a, accuracy: 0.01, "Alpha component mismatch")
        }
    }
    
    // 测试半透明颜色转换
    func testTransparentColorConversion() throws {
        // 测试不同透明度的颜色
        let transparentColors: [(Double, Double, Double, Double)] = [
            (1.0, 0.0, 0.0, 0.5), // 半透明红色
            (0.0, 1.0, 0.0, 0.3), // 30%不透明绿色
            (0.0, 0.0, 1.0, 0.7), // 70%不透明蓝色
            (0.5, 0.5, 0.5, 0.2) // 20%不透明灰色
        ]
        
        for (r, g, b, a) in transparentColors {
            let color = Color(.sRGB, red: r, green: g, blue: b, opacity: a)
            let aColor = try XCTUnwrap(AColor(color), "Failed to convert transparent color to AColor")
            
            // 验证透明度是否正确保留
            XCTAssertEqual(aColor.alpha, a, accuracy: 0.01, "Alpha component mismatch")
        }
    }
    
    // 测试AColor的solidColor属性
    func testSolidColorProperty() throws {
        // 测试半透明颜色转换为不透明颜色
        let semiTransparentColor = Color(.sRGB, red: 0.5, green: 0.5, blue: 0.5, opacity: 0.5)
        let aColor = try XCTUnwrap(AColor(semiTransparentColor), "Failed to convert semi-transparent color to AColor")
        
        // 从原始半透明AColor获取solidColor
        let solidColor = aColor.solidColor
        
        // 将solidColor转换回AColor并验证alpha值为1.0
        let solidAColor = try XCTUnwrap(AColor(solidColor), "Failed to convert solidColor back to AColor")
        XCTAssertEqual(solidAColor.alpha, 1.0, accuracy: 0.01, "solidColor should have alpha value of 1.0")
        
        // 验证RGB值保持不变
        XCTAssertEqual(solidAColor.red, aColor.red, accuracy: 0.01, "Red component should remain the same in solidColor")
        XCTAssertEqual(solidAColor.green, aColor.green, accuracy: 0.01, "Green component should remain the same in solidColor")
        XCTAssertEqual(solidAColor.blue, aColor.blue, accuracy: 0.01, "Blue component should remain the same in solidColor")
    }
    
    // 测试AttributedString生成功能
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    func testAttributedStringGeneration() throws {
        // 测试在暗色模式下需要背景色的颜色
        let darkColor = Color(.sRGB, red: 0.1, green: 0.1, blue: 0.1, opacity: 1.0)
        let aDarkColor = try XCTUnwrap(AColor(darkColor), "Failed to convert dark color to AColor")
        
        // 生成暗色模式下的AttributedString
        let darkModeString = aDarkColor.attributedString(for: .dark)
        
        // 验证字符串内容是否为颜色的描述
        XCTAssertEqual(String(darkModeString.characters), aDarkColor.description, "AttributedString content should match color description")
        
        // 测试在亮色模式下需要背景色的颜色
        let lightColor = Color(.sRGB, red: 0.9, green: 0.9, blue: 0.9, opacity: 1.0)
        let aLightColor = try XCTUnwrap(AColor(lightColor), "Failed to convert light color to AColor")
        
        // 生成亮色模式下的AttributedString
        let lightModeString = aLightColor.attributedString(for: .light)
        
        // 验证字符串内容是否为颜色的描述
        XCTAssertEqual(String(lightModeString.characters), aLightColor.description, "AttributedString content should match color description")
    }
    
    // 测试随机颜色的Color和AColor的description是否相同
    func testRandomColorDescriptionEquality() throws {
        // 生成指定数量的随机颜色
        let numberOfRandomColors = 10
        var randomColors: [Color] = []
        
        for _ in 0 ..< numberOfRandomColors {
            // 生成随机的RGB和alpha值
            let r = Double.random(in: 0.0...1.0)
            let g = Double.random(in: 0.0...1.0)
            let b = Double.random(in: 0.0...1.0)
            let a = Double.random(in: 0.0...1.0)
            
            // 创建随机颜色
            randomColors.append(Color(.sRGB, red: r, green: g, blue: b, opacity: a))
        }
        
        for color in randomColors {
            // 将Color转换为AColor
            let aColor = try XCTUnwrap(AColor(color), "Failed to convert random color to AColor")
            
            // 获取AColor的description
            let aColorDescription = aColor.description
            
            // 验证转换前后的description是否相同
            XCTAssertEqual(aColor.original, color, "Description should match after round trip conversion")
            
            // 验证转换前后的description是否相同
            XCTAssertEqual(aColorDescription, color.description, "Description should match after round trip conversion")
        }
    }
}
