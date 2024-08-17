import AUnit
import Foundation

public extension AFunction {
    enum Part: Codable, Sendable, Hashable {
        case math
        case points
        case geography
    }
}
