import Foundation
import simd

public typealias AVector = SIMD2<Double>

extension AVector: AVectorProtocol {}

public extension AVector {
    static var zero: SIMD2<Double> = .init(x: 0, y: 0)
}
