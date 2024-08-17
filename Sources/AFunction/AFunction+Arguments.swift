public extension AFunction {
    enum Arguments: Codable, Sendable, Hashable {
        case finite([Argument])
        case withOptional([Argument], optionals: [Argument])
        case withInfinite([Argument], infinite: Argument)
    }
}
