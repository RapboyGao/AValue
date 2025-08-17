import Foundation

public struct AColor: Codable, Sendable, Hashable, CustomStringConvertible {
    public var colorSpace: AColorSpace
    public var red: Double
    public var green: Double
    public var blue: Double
    public var alpha: Double
    
    @available(iOS 14.0, tvOS 14.0, watchOS 7.0, macOS 11, *)
    public var original: Color {
        get {
            Color(colorSpace.original, red: red, green: green, blue: blue, opacity: alpha)
        }
        set {
            guard let newColor = AColor(newValue)
            else { return }
            self = newColor
        }
    }

    @available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
    public init?(_ color: Color?) {
        guard let color = color else {
            return nil
        }
        
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        
        // iOS、tvOS和watchOS都使用UIKit
        #if canImport(UIKit)
            let uiColor = UIColor(color)
            
            // 检查是否成功获取RGB组件
            guard uiColor.getRed(&r, green: &g, blue: &b, alpha: &a) else {
                // 尝试将颜色转换为RGB颜色空间
                if let rgbColor = uiColor.cgColor.converted(to: CGColorSpaceCreateDeviceRGB(), intent: .defaultIntent, options: nil) {
                    if let components = rgbColor.components, components.count >= 4 {
                        r = CGFloat(components[0])
                        g = CGFloat(components[1])
                        b = CGFloat(components[2])
                        a = CGFloat(components[3])
                    } else {
                        return nil
                    }
                }
                return nil
            }
            
            self.red = Double(r)
            self.green = Double(g)
            self.blue = Double(b)
            self.alpha = Double(a)
            
            // 尝试找到匹配的颜色空间
            for myColorSpace in AColorSpace.allCases {
                let someColor = Color(myColorSpace.original, red: r, green: g, blue: b, opacity: a)
                if someColor == color {
                    self.colorSpace = myColorSpace
                    return
                }
            }
            
            // 如果找不到匹配的颜色空间，使用默认的sRGB
            self.colorSpace = .sRGB
        #elseif canImport(AppKit)
            // macOS使用AppKit的实现保持不变
            let nsColor = NSColor(color)
            let converted = nsColor.usingColorSpace(.deviceRGB) ?? nsColor
            r = converted.redComponent
            g = converted.greenComponent
            b = converted.blueComponent
            a = converted.alphaComponent
            self.red = Double(r)
            self.green = Double(g)
            self.blue = Double(b)
            self.alpha = Double(a)
            
            // 尝试找到匹配的颜色空间
            for myColorSpace in AColorSpace.allCases {
                let someColor = Color(myColorSpace.original, red: r, green: g, blue: b, opacity: a)
                if someColor == color {
                    self.colorSpace = myColorSpace
                    return
                }
            }
            
            // 如果找不到匹配的颜色空间，使用默认的sRGB
            self.colorSpace = .sRGB
        #elseif canImport(CoreGraphics) && canImport(SwiftUI)
            // 作为最后的备选方案，尝试使用CGColor直接转换
            if let cgColor = color.cgColor {
                if let components = cgColor.components, components.count >= 3 {
                    self.red = Double(components[0])
                    self.green = Double(components[1])
                    self.blue = Double(components[2])
                    self.alpha = components.count >= 4 ? Double(components[3]) : 1.0
                    self.colorSpace = .sRGB
                    return
                }
            }
        #endif
        // 无法从Color创建AColor
        return nil
    }

    public init(colorSpace: AColorSpace, red: Double, green: Double, blue: Double, alpha: Double) {
        self.colorSpace = colorSpace
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    public var description: String {
        // Convert color components from Double (0.0-1.0) to UInt8 (0-255)
        let r = UInt8(clamping: Int(red * 255.0))
        let g = UInt8(clamping: Int(green * 255.0))
        let b = UInt8(clamping: Int(blue * 255.0))
        let a = UInt8(clamping: Int(alpha * 255.0))

        // Format as hexadecimal string in the format #RRGGBBAA
        return String(format: "#%02X%02X%02X%02X", r, g, b, a)
    }
}
