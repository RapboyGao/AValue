import AUnit

public struct AValueArrayElement: Hashable, Codable, Sendable, Identifiable {
    /// 在数组中的索引
    public var id: Int
    public var value: AValue
    public var isLast: Bool
    public var isFirst: Bool
    public var unit: AUnit?
    public var name: String?

    public init(id: Int, value: AValue, isLast: Bool, name: String? = nil) {
        self.id = id
        self.value = value
        self.isLast = isLast
        self.isFirst = id == 0
        self.unit = nil
    }

    public init(id: Int, value: AValue, isLast: Bool, unit: AUnit, name: String? = nil) {
        self.id = id
        self.value = value
        self.isLast = isLast
        self.isFirst = id == 0
        self.unit = unit
        self.name = name
    }
}

public extension [AValueArrayElement] {
    init(_ values: [AValue]) {
        self = values.enumerated().map {
            AValueArrayElement(id: $0.offset, value: $0.element, isLast: $0.offset == values.count - 1)
        }
    }
}
