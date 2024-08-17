import AValue

public extension AFunction {
    enum ArgumentType: Codable, Sendable, Hashable {
        case anything
        case collection([AValueType])
        case one(AValueType)
    }
}
