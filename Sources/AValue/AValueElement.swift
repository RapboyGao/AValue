import AUnit

public struct AValueArrayElement: Hashable, Codable, Sendable, Identifiable {
    public var id: Int
    public var value: AValue
    public var isLast: Bool
    public var isFirst: Bool
    public var unit: AUnit?

    public init(id: Int, value: AValue, isLast: Bool) {
        self.id = id
        self.value = value
        self.isLast = isLast
        self.isFirst = id == 0
    }
}

public extension [AValueArrayElement] {
    init(_ values: [AValue]) {
        self = values.enumerated().map {
            AValueArrayElement(id: $0.offset, value: $0.element, isLast: $0.offset == values.count - 1)
        }
    }
}
