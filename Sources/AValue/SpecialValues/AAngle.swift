import Foundation

private let twoPi = 6.283185307179586
private let factor57 = 57.29577951308232

public protocol AAngleProtocol: AdditiveArithmetic, Hashable, Sendable, Codable, CustomStringConvertible, Comparable {
    var radians: Double { get set }
    var degrees: Double { get set }
    init(radians: Double)
    init(degrees: Double)
    static func degrees(_ value: Double) -> Self
    static func radians(_ value: Double) -> Self
}

public extension AAngleProtocol {
    func cos() -> Double {
        Darwin.cos(radians)
    }

    func sin() -> Double {
        Darwin.sin(radians)
    }

    func tan() -> Double {
        Darwin.tan(radians)
    }

    func sinh() -> Double {
        Darwin.sinh(radians)
    }

    func cosh() -> Double {
        Darwin.cosh(radians)
    }

    func tanh() -> Double {
        Darwin.tanh(radians)
    }

    var description: String {
        String(degrees) + "degrees  " + String(radians) + " rad"
    }

    var asAngle: AAngle {
        (self as? AAngle) ?? AAngle(radians: radians)
    }

    static func + (left: Self, right: Self) -> Self {
        Self(radians: left.radians + right.radians)
    }

    static func - (left: Self, right: Self) -> Self {
        Self(radians: left.radians - right.radians)
    }

    static func < (left: Self, right: Self) -> Bool {
        left.degrees < right.degrees
    }

    static func degrees(_ value: Double) -> Self {
        .init(degrees: value)
    }

    static func radians(_ value: Double) -> Self {
        .init(radians: value)
    }

    static func aCos(_ value: Double) -> Self {
        .init(radians: Darwin.acos(value))
    }

    static func aSin(_ value: Double) -> Self {
        .init(radians: Darwin.asin(value))
    }

    static func aTan(_ value: Double) -> Self {
        .init(radians: Darwin.atan(value))
    }
}

public struct AAngle: AAngleProtocol {
    /// 存储的角度Double
    private var angle: Double
    /// 存储是否为弧度
    private var isRadian: Bool

    public func isNormalOrZero() -> Bool {
        angle.isNormal || angle.isZero
    }

    public func isNormal() -> Bool {
        angle.isNormal
    }

    /// 弧度
    public var radians: Double {
        get {
            isRadian ? angle : (angle / factor57)
        }
        set {
            angle = newValue
            isRadian = true
        }
    }

    /// 度
    public var degrees: Double {
        get {
            isRadian ? angle * factor57 : angle
        }
        set {
            angle = newValue
            isRadian = false
        }
    }

    public init(radians: Double) {
        angle = radians
        isRadian = true
    }

    public init(degrees: Double) {
        angle = degrees
        isRadian = false
    }
}

public extension AAngle {
    static let zero = AAngle(degrees: 0)

    func hash(into hasher: inout Hasher) {
        hasher.combine(radians)
    }

    mutating func cacheDegrees() {
        angle = degrees
        isRadian = false
    }

    mutating func cacheRadians() {
        angle = radians
        isRadian = true
    }

    /// - Returns: [0, 360) angle
    func in360() -> AAngle {
        var res = self
        guard res.angle.isNormal
        else { return res }
        res.cacheRadians()
        let scale = (res.angle / twoPi).rounded(.down)
        res.angle -= scale * twoPi
        return res
    }

    /// - Parameter include180: 是否包含180度
    /// - Returns: 根据是否包含180度，确定[-180,180) 还是(-180,180]
    func in180(include180: Bool) -> AAngle {
        var res = self
        guard res.angle.isNormal
        else { return res }
        res.cacheRadians()
        let scale = (res.angle / twoPi).rounded(.down)
        res.angle -= scale * twoPi
        switch include180 {
        case true:
            if res.angle > .pi {
                res.angle -= twoPi
            }
        case false:
            if res.angle >= .pi {
                res.angle -= twoPi
            }
        }
        return res
    }

    /// - Returns: 先转为正负180度，在转为绝对值
    func in180ThenAbs() -> AAngle {
        let radians = in180(include180: true)
            .radians
        return AAngle(radians: abs(radians))
    }

    /// - Returns: (-360,0] Angle
    func inM360() -> AAngle {
        var res = self
        guard res.angle.isNormal
        else { return res }
        res.cacheRadians()
        let scale = (res.angle / twoPi).rounded(.up)
        res.angle -= scale * twoPi
        return res
    }
}
