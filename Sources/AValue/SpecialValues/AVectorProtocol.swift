import AUnits
import Foundation
import simd

public protocol AVectorProtocol: Hashable, Codable, Sendable, AdditiveArithmetic {
    var x: Double { get set }
    var y: Double { get set }
    init(x: Double, y: Double)
}

public extension AVectorProtocol {
    init(atan2 angle: AAngle, length: Double) {
        self.init(x: length * angle.cos(), y: length * angle.sin())
    }

    init(towards angle: AAngle, length: Double) {
        self.init(x: angle.sin() * length, y: angle.cos() * length)
    }

    init(from angle: AAngle, length: Double) {
        self.init(x: -angle.sin() * length, y: -angle.cos() * length)
    }
}

public extension AVectorProtocol {
    var length: Double {
        get {
            if let self = self as? SIMD2<Double> {
                return simd_fast_length(self)
            } else {
                return simd_fast_length(simd_double2(x: x, y: y))
            }
        }
        set {
            guard atan2.isNormalOrZero()
            else {
                self = Self(towards: .zero, length: newValue)
                return
            }
            self = Self(towards: rawCompassTowards, length: newValue)
        }
    }

    private var validLength: Double {
        let length = length
        guard length.isNormal
        else {
            return 1e-10
        }
        return length
    }

    var isValid: Bool {
        (x.isNormal || x.isZero) && (y.isNormal || y.isZero)
    }

    var atan2: AAngle {
        get {
            .radians(Darwin.atan2(y, x))
        }
        set {
            self = Self(atan2: newValue, length: validLength)
        }
    }

    var rawCompassTowards: AAngle {
        .radians(Darwin.atan2(x, y))
    }

    var compassTowards: AAngle {
        get {
            rawCompassTowards.in360()
        }
        set {
            self = Self(towards: newValue, length: validLength)
        }
    }

    var rawCompassFrom: AAngle {
        .radians(Darwin.atan2(-x, -y))
    }

    var compassFrom: AAngle {
        get {
            rawCompassFrom.in360()
        }
        set {
            self = Self(from: newValue, length: validLength)
        }
    }

    func toReversed<T: AVectorProtocol>() -> T {
        T(x: -x, y: -y)
    }

    mutating func reverse() {
        x = -x
        y = -y
    }

    func toGeneral<T: AVectorProtocol>() -> T {
        (self as? T) ?? T(x: x, y: y)
    }

    static func + (left: Self, right: Self) -> Self {
        .init(x: left.x + right.x, y: left.y + right.y)
    }

    static func - (left: Self, right: Self) -> Self {
        .init(x: left.x - right.x, y: left.y - right.y)
    }
}
