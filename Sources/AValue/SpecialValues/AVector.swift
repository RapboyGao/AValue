import Foundation
import simd

public struct AVector: Codable, Sendable, Hashable, AVectorProtocol {
    public var x: Double
    public var y: Double

    public static let zero = Self(x: 0, y: 0)

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }

    public var length: Double {
        simd_fast_length(.init(x: x, y: y))
    }
}
