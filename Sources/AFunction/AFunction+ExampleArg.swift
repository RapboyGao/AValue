import AValue
import Foundation

public extension AFunction {
    struct ExampleArg: Codable, Sendable, Hashable, Identifiable {
        public let id: UUID
        public let arguments: [AValue]
        public init(_ arguments: [AValue]) {
            self.id = UUID()
            self.arguments = arguments
        }
    }
}
