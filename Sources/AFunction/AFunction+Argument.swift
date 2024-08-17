import AUnit
import Foundation

public extension AFunction {
    struct Argument: Codable, Sendable, Hashable, Identifiable {
        public var id = UUID()
        public var name: String
        public var detail: String
        // 可以接受的数据类型
        public var type: ArgumentType
        public var constraint: ANumberConstraint = .realNumber(.infiniteRange)
        public var unit: AUnit?
    }
}
