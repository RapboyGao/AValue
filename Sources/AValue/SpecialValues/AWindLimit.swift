import AUnit
import Foundation

public enum AWindLimitType: Int, RawRepresentable, Hashable, Sendable, Codable {
    case withinLimit = 0, headWind, tailWind, crossWind, totalWind
}

public struct AWindLimitStatus: Hashable, Sendable, Codable, Identifiable {
    public var id = UUID()
    public var code: AWindLimitType
    /// 最大风速限制
    public var limit: Double
    public var windDir: AAngle
    public var runway: AAngle

    public var diff: AAngle {
        (windDir - runway).in180(include180: true)
    }
}

public struct AWindLimit: Hashable, Sendable, Codable {
    private var headWindWrapped: Double
    private var tailWindWrapped: Double
    private var crossWindWrapped: Double
    private var totalWindWrapped: Double
    private var runwayHeadingWrapped: AAngle

    public var headWind: Double {
        get { headWindWrapped }
        set { headWindWrapped = abs(newValue) }
    }

    public var tailWind: Double {
        get { tailWindWrapped }
        set { tailWindWrapped = abs(newValue) }
    }

    public var crossWind: Double {
        get { crossWindWrapped }
        set { crossWindWrapped = abs(newValue) }
    }

    public var totalWind: Double {
        get { totalWindWrapped }
        set { totalWindWrapped = abs(newValue) }
    }

    public var runwayHeading: AAngle {
        get { runwayHeadingWrapped }
        set { runwayHeadingWrapped = newValue.in360() }
    }

    public var maxOfWinds: Double {
        max(headWindWrapped, tailWindWrapped, crossWindWrapped, totalWindWrapped.isFinite ? totalWindWrapped : 0)
    }

    public var isValid: Bool {
        guard headWindWrapped.isNormal || headWindWrapped.isZero,
              tailWindWrapped.isNormal || tailWindWrapped.isZero,
              crossWindWrapped.isNormal || crossWindWrapped.isZero,
              totalWindWrapped.isNormal || totalWindWrapped.isZero || totalWindWrapped.isInfinite,
              runwayHeadingWrapped.isNormalOrZero()
        else { return false }
        return true
    }

    public init(headWind: Double, tailWind: Double, crossWind: Double, totalWind: Double? = nil, runwayHeading: AAngle? = nil) {
        headWindWrapped = abs(headWind)
        tailWindWrapped = abs(tailWind)
        crossWindWrapped = abs(crossWind)
        if let totalWind = totalWind {
            totalWindWrapped = abs(totalWind)
        } else {
            totalWindWrapped = max(sqrt(pow(headWind, 2) + pow(crossWind, 2)), sqrt(pow(tailWind, 2) + pow(crossWind, 2)))
        }
        runwayHeadingWrapped = runwayHeading?.in360() ?? .zero
    }

    public static var b737 = AWindLimit(headWind: 50, tailWind: 10, crossWind: 30)
}

public extension AWindLimit {
    private func betweenRunwayHeading(heading: AAngle) -> AAngle {
        heading - runwayHeadingWrapped
    }

    func maxWind(from angle: AAngle) -> AWindLimitStatus {
        let angleDiff = betweenRunwayHeading(heading: angle)

        let _maxWindByHeadOrTailWind: Double

        // 顶顺风
        let _cos = angleDiff.cos()
        if _cos > 0 {
            _maxWindByHeadOrTailWind = headWindWrapped / abs(_cos)
        } else if _cos.isZero {
            _maxWindByHeadOrTailWind = .infinity
        } else {
            _maxWindByHeadOrTailWind = tailWindWrapped / abs(_cos)
        }

        // 侧风
        let _sin = abs(angleDiff.sin())
        let _maxWindByCrossWind: Double
        if _sin.isZero {
            _maxWindByCrossWind = .infinity
        } else {
            _maxWindByCrossWind = crossWindWrapped / _sin
        }

        // 风限汇总
        let _limit = min(_maxWindByHeadOrTailWind, _maxWindByCrossWind, totalWindWrapped)

        switch _limit {
        case _maxWindByHeadOrTailWind:
            let limitType: AWindLimitType = _cos >= 0 ? .headWind : .tailWind
            return .init(code: limitType, limit: _limit, windDir: angle, runway: runwayHeading)
        case _maxWindByCrossWind:
            return .init(code: .crossWind, limit: _limit, windDir: angle, runway: runwayHeading)
        default:
            return .init(code: .totalWind, limit: _limit, windDir: angle, runway: runwayHeading)
        }
    }

    func usefulData() -> [AWindLimitStatus] {
        stride(from: 0, to: 360, by: 10)
            .map { angleInDegrees in
                maxWind(from: .degrees(angleInDegrees))
            }
    }

    mutating func convert(from unit: AUnit, to newUnit: AUnit?) {
        guard let newUnit = newUnit,
              unit.unitType == .speed
        else { return }
        crossWindWrapped = unit.convert(value: crossWindWrapped, to: newUnit) ?? crossWindWrapped
        headWindWrapped = unit.convert(value: headWindWrapped, to: newUnit) ?? headWindWrapped
        tailWindWrapped = unit.convert(value: tailWindWrapped, to: newUnit) ?? tailWindWrapped
        totalWindWrapped = unit.convert(value: totalWindWrapped, to: newUnit) ?? totalWindWrapped
    }

    func converted(from unit: AUnit, to newUnit: AUnit?) -> AWindLimit {
        var copied = self
        copied.convert(from: unit, to: newUnit)
        return copied
    }
}
