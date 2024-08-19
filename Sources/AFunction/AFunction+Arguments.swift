public extension AFunction {
    enum Arguments: Codable, Sendable, Hashable, CustomStringConvertible {
        case finite([Argument])
        case withOptional([Argument], optionals: [Argument])
        case withInfinite([Argument], infinite: Argument)

        public var description: String {
            switch self {
            case .finite(let array):
                return array.map(\.name).joined(separator: ",")
            case .withOptional(let array, let optionals):
                let totalArray = array.map(\.name) + optionals.map { $0.name + "?" }
                return totalArray.joined(separator: ",")
            case .withInfinite(let array, let infinite):
                let totalArray = array.map(\.name) + [infinite.name + ".."]
                return totalArray.joined(separator: ",")
            }
        }
    }
}
